#!/bin/bash
set -e
set -x

source $(dirname $0)/entry

cd $(dirname $0)/../../../..

latest_chart=$(find ./charts/prometheus-federator -type d -maxdepth 1 -mindepth 1 | tr - \~ | sort -rV | tr \~ - | head -n1)

case "${KUBERNETES_DISTRIBUTION_TYPE}" in
"k3s")
    cluster_args=""
    kubernetes_version=$(kubectl version --short | grep "Server Version" | cut -d ' ' -f3)
    case "${kubernetes_version}" in
    v1.23.*)
        embedded_helm_controller_fixed_version="v1.23.14"
        if [[ $(echo ${kubernetes_version} ${embedded_helm_controller_fixed_version} | tr " " "\n" | sort -rV | head -n 1 ) == "${embedded_helm_controller_fixed_version}" ]]; then
            cluster_args="--set helmProjectOperator.helmController.enabled=false"
        fi
        ;;
    v1.24.*)
        embedded_helm_controller_fixed_version="v1.24.8"
        if [[ $(echo ${kubernetes_version} ${embedded_helm_controller_fixed_version} | tr " " "\n" | sort -rV | head -n 1 ) == "${embedded_helm_controller_fixed_version}" ]]; then
            cluster_args="--set helmProjectOperator.helmController.enabled=false"
        fi
        ;;
    v1.25.*)
        embedded_helm_controller_fixed_version="v1.25.4"
        if [[ $(echo ${kubernetes_version} ${embedded_helm_controller_fixed_version} | tr " " "\n" | sort -rV | head -n 1 ) == "${embedded_helm_controller_fixed_version}" ]]; then
            cluster_args="--set helmProjectOperator.helmController.enabled=false"
        fi
        ;;
    esac
    ;;
"rke")
    cluster_args=""
    ;;
"rke2")
    cluster_args=""
    kubernetes_version=$(kubectl version --short | grep "Server Version" | cut -d ' ' -f3)
    case "${kubernetes_version}" in
    v1.23.*)
        embedded_helm_controller_fixed_version="v1.23.14"
        if [[ $(echo ${kubernetes_version} ${embedded_helm_controller_fixed_version} | tr " " "\n" | sort -rV | head -n 1 ) == "${embedded_helm_controller_fixed_version}" ]]; then
            cluster_args="--set helmProjectOperator.helmController.enabled=false"
        fi
        ;;
    v1.24.*)
        embedded_helm_controller_fixed_version="v1.24.8"
        if [[ $(echo ${kubernetes_version} ${embedded_helm_controller_fixed_version} | tr " " "\n" | sort -rV | head -n 1 ) == "${embedded_helm_controller_fixed_version}" ]]; then
            cluster_args="--set helmProjectOperator.helmController.enabled=false"
        fi
        ;;
    v1.25.*)
        embedded_helm_controller_fixed_version="v1.25.4"
        if [[ $(echo ${kubernetes_version} ${embedded_helm_controller_fixed_version} | tr " " "\n" | sort -rV | head -n 1 ) == "${embedded_helm_controller_fixed_version}" ]]; then
            cluster_args="--set helmProjectOperator.helmController.enabled=false"
        fi
        ;;
    esac
    ;;
*)
    echo "KUBERNETES_DISTRIBUTION_TYPE=${KUBERNETES_DISTRIBUTION_TYPE} is unknown"
    exit 1
esac

helm upgrade --install --create-namespace -n cattle-monitoring-system prometheus-federator --set helmProjectOperator.image.repository=${REPO:-rancher}/prometheus-federator --set helmProjectOperator.image.tag=${TAG:-dev} ${cluster_args} ${RANCHER_HELM_ARGS} ${latest_chart}

echo "PASS: Prometheus Federator has been installed"
