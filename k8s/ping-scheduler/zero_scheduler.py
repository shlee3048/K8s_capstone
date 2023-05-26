import time
import requests
from kubernetes import client, config
import random


class Scheduler:
    def __init__(self, cfg=None):
        if cfg is None:
            self.config = config.load_kube_config()
        else:
            self.config = cfg

        self.core_api = client.CoreV1Api()
        self.alb_url = 'http://k8s-testingr-ingress2-0b8c0f0efc-998273603.ap-northeast-2.elb.amazonaws.com'

    def measure_latency(self):
        start_time = time.time()
        response = requests.get(self.alb_url)
        end_time = time.time()

        if response.status_code == 200:
            return end_time - start_time
        else:
            return None

    def choose_best_node(self, nodes):
        weighted_nodes = []
        for node in nodes:
            if node.metadata.name.startswith('k8s-master'):
                continue

            node_latency = self.measure_latency()
            if node_latency is None or (node_latency*1000) > 100:
                continue

            weight = int((150 - (node_latency*1500)) * 1.5)
            weighted_nodes.extend([node] * weight)

        if not weighted_nodes:
            return None

        return random.choice(weighted_nodes)

    def _bind_pod_to_node(self, pod, node_name, debug=False):
        pod_name = pod.metadata.name
        if debug:
            print(f"Pod: {pod_name}, status: {pod.status.phase}")

        if pod.status.phase == "Pending":
            print(f"Pod [{pod_name}] is scheduled to node [{node_name}]")
            try:
                body = client.V1Binding(
                    metadata=client.V1ObjectMeta(
                        name=pod_name,
                        namespace="default"
                    ),
                    target=client.V1ObjectReference(
                        api_version="v1",
                        kind="Node",
                        name=node_name,
                        namespace="default"
                    )
                )
                self.core_api.create_namespaced_binding(
                    body=body,
                    namespace="default"
                )
            except Exception as e:
                pass
        else:
            print(f"Pod {pod_name} is already scheduled to node {pod.spec.node_name}")

    def get_unscheduled_pods(self):
        unscheduled_pods = self.core_api.list_namespaced_pod(namespace="default", field_selector="spec.nodeName==,status.phase=Pending")
        return unscheduled_pods.items

    def schedule_unscheduled_pods(self, debug=False):
        unscheduled_pods = self.get_unscheduled_pods()
        nodes = self.core_api.list_node().items

        for pod in unscheduled_pods:
            best_node = self.choose_best_node(nodes)
            if best_node:
                self._bind_pod_to_node(pod, best_node.metadata.name, debug)
            else:
                print(f"No suitable node found for pod '{pod.metadata.name}'")


if __name__ == "__main__":
    scheduler = Scheduler()
    scheduler.schedule_unscheduled_pods(debug=True)
