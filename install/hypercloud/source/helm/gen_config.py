from typing import Dict
import yaml


def create_tibero_values(
  global_values: Dict
):
  # global option
  enable_loadbalancer = global_values["loadbalancer"]["enabled"]
  registry_ip = global_values["registry"]["ip"]
  registry_port = global_values["registry"]["port"]
  registry_repository = global_values["registry"]["repository"]["base"]
  if registry_repository:
    registry_repository += "/"
  
  ip = global_values["ip"]

  # tibero option
  tibero_image = global_values["tibero"]["image"]

  tibero_options = {
    "tibero": {
      "image": f"{registry_ip}:{registry_port}/{registry_repository}{tibero_image}",
      "loadbalancer": {
        "enabled": enable_loadbalancer,
        "ip": ip
      }
    }
  }
  return tibero_options


def create_nginx_values(
  global_values: Dict
):
  # global option
  namespace = global_values["namespace"]
  enable_loadbalancer = global_values["loadbalancer"]["enabled"]
  enable_https = global_values["https"]["enabled"]
  registry_ip = global_values["registry"]["ip"]
  registry_port = global_values["registry"]["port"]
  registry_repository = global_values["registry"]["repository"]["base"]
  if registry_repository:
    registry_repository += "/"

  ip = global_values["ip"]

  # nginx option
  port = global_values["nginx"]["port"]
  nginx_controller_image = global_values["nginx"]["controller"]["image"]
  nginx_admissionwebhook_image = global_values["nginx"]["admissionWebhooks"]["image"]

  nginx_options = {
    "nginx": {
      "rbac": {
        "scope": True,
        "create": True
      },
      "controller": {
        "scope": {
          "enabled": True,
          "namespace": namespace
        },
        "image": {
          "name": f"{registry_ip}:{registry_port}/{registry_repository}{nginx_controller_image}"
        },
        "service": {
          "ports": {}
        },
        "admissionWebhooks": {
          "enabled": False,
          #"namespaceSelector": {
          #  "matchLabels": {
          #    "namespace": namespace
          #  }
          #},
          #"patch": {
          #  "image": {
          #    "name": f"{registry_ip}:{registry_port}/{nginx_admissionwebhook_image}"
          #  }
          #}
        }
      }
    }
  }
  if enable_loadbalancer:
    nginx_options["nginx"]["controller"]["service"]["enabled"] = True
    nginx_options["nginx"]["controller"]["service"]["annotations"] = {
      "metallb.universe.tf/allow-shared-ip": "top"
    }
    nginx_options["nginx"]["controller"]["service"]["type"] = "LoadBalancer"
    nginx_options["nginx"]["controller"]["service"]["loadBalancerIP"] = ip
    nginx_options["nginx"]["controller"]["service"]["sessionAffinity"] = "None"
    nginx_options["nginx"]["controller"]["service"]["externalTrafficPolicy"] = "Cluster"

    if enable_https:
      nginx_options["nginx"]["controller"]["service"]["ports"]["https"] = port
    else:
      nginx_options["nginx"]["controller"]["service"]["ports"]["http"] = port
  else:
    nginx_options["nginx"]["controller"]["service"]["type"] = "NodePort"
    
    if port < 30000 and port > 32767:
      print("If loadbalancer is disabled, port range must be in 30000~32767")
      exit(1)
    if enable_https:
      nginx_options["nginx"]["controller"]["service"]["ports"]["https"] = port
      nginx_options["nginx"]["controller"]["service"]["nodePorts"] = {
        "https": port
      }
    else:
      nginx_options["nginx"]["controller"]["service"]["ports"]["http"] = port
      nginx_options["nginx"]["controller"]["service"]["nodePorts"] = {
        "http": port
      }    
  return nginx_options


def create_hyperdata_values(
  global_values: Dict
):
  # global option
  namespace = global_values["namespace"]
  enable_loadbalancer = global_values["loadbalancer"]["enabled"]
  enable_https = global_values["https"]["enabled"]
  registry_ip = global_values["registry"]["ip"]
  registry_port = global_values["registry"]["port"]
  registry_repository = global_values["registry"]["repository"]["base"]
  if registry_repository:
    registry_repository += "/"

  mllab_repository =  global_values["registry"]["repository"]["mllab"]
  registry_secret = global_values["registry"]["secret"]
  ip = global_values["ip"]
  kubeflow_ip = global_values["kubeflow"]["ip"]
  notebook_port = global_values["kubeflow"]["ports"]["notebook"]

  # hyperdata_option
  hyperdata_image = global_values["hyperdata"]["image"]
  proxy_bodysize = global_values["hyperdata"]["proxy"]["bodysize"]
  proxy_timeout = global_values["hyperdata"]["proxy"]["timeout"]

  # nginx option
  webserver_port = global_values["nginx"]["port"]

  # automl option
  automl_frontend_subdir = global_values["automl"]["frontendSubDir"]
  if not str(automl_frontend_subdir).startswith("/"):
    automl_frontend_subdir = "/" + automl_frontend_subdir
  automl_frontend = f"{ip}:{webserver_port}{automl_frontend_subdir}"
  automl_backend_subdir = global_values["automl"]["backendSubDir"]
  if not str(automl_backend_subdir).startswith("/"):
    automl_backend_subdir = "/" + automl_backend_subdir
  automl_backend = f"{ip}:{webserver_port}{automl_backend_subdir}"

  hyperdata_options = {
    "hyperdata": {
      "image": f"{registry_ip}:{registry_port}/{registry_repository}{hyperdata_image}",
      "registry": {
        "enabled": "true",
        "ip": registry_ip,
        "port": registry_port,
        "secret": registry_secret
      },
      "proxy": {
        "bodysize": proxy_bodysize,
        "timeout": proxy_timeout
      },
      "https": {
        "enabled": "true" if enable_https else "false"
      },
      "webserver": {
        "ip": ip,
        "port": webserver_port
      },
      "automl": {
        "frontend": automl_frontend,
        "backend": automl_backend
      },
      "kubeflow": {
        "ip": kubeflow_ip,
        "ports": {
          "notebook": notebook_port
        }
      },
      "loadbalancer": {
        "enabled": "true" if enable_loadbalancer else "false"
      }
    }
  }

  return hyperdata_options


def create_automl_values(
  global_values: Dict
):
  # global option
  namespace = global_values["namespace"]
  enable_loadbalancer = global_values["loadbalancer"]["enabled"]
  enable_https = global_values["https"]["enabled"]
  registry_ip = global_values["registry"]["ip"]
  registry_port = global_values["registry"]["port"]
  registry_repository = global_values["registry"]["repository"]["base"]
  if registry_repository:
    registry_repository += "/"

  registry_secret = global_values["registry"]["secret"]
  ip = global_values["ip"]
  registry_prefix = f"{registry_ip}:{registry_port}/{registry_repository}"
  kubeflow_ip = global_values["kubeflow"]["ip"]
  kfserving_port = global_values["kubeflow"]["ports"]["kfserving"]

  # nginx option
  webserver_port = global_values["nginx"]["port"]

  # automl options
  automl_frontend_subdir = global_values["automl"]["frontendSubDir"]
  automl_backend_subdir = global_values["automl"]["backendSubDir"]

  automl_options = {
    "automl": {
      "registry": {
        "ip": registry_ip,
        "port": registry_port,
        "secret": registry_secret
      },
      "https": {
        "enabled": "true" if enable_https else "false"
      },
      "webserver": {
        "ip": ip,
        "port": webserver_port
      },
      "frontendSubDir": automl_frontend_subdir,
      "backendSubDir": automl_backend_subdir,
      "image": {
        "automl": registry_prefix + global_values["automl"]["image"]["automl"],
        "doloader": registry_prefix + global_values["automl"]["image"]["doloader"],
        "fe": registry_prefix + global_values["automl"]["image"]["fe"],
        "xgb": registry_prefix + global_values["automl"]["image"]["xgb"],
        "rf": registry_prefix + global_values["automl"]["image"]["rf"],
        "downloader": registry_prefix + global_values["automl"]["image"]["downloader"],
        "scheduler": registry_prefix + global_values["automl"]["image"]["scheduler"],
        "woori": registry_prefix + global_values["automl"]["image"]["woori"],
        "resultuploader": registry_prefix + global_values["automl"]["image"]["resultuploader"],
        "domainserving": registry_prefix + global_values["automl"]["image"]["domainserving"],
        "wooriserving": registry_prefix + global_values["automl"]["image"]["wooriserving"]
      },
      "kubeflow": {
        "ip": kubeflow_ip,
        "ports": {
          "kfserving": kfserving_port
        }
      }
    }
  }  

  return automl_options


if __name__ == "__main__":
  with open("global_values.yaml", "r") as f:
    global_values = yaml.safe_load(f.read())

  # for tibero
  tibero_values = create_tibero_values(global_values)

  # for nginx
  nginx_values = create_nginx_values(global_values)

  # for hyperdata
  hyperdata_values = create_hyperdata_values(global_values)

  # for automl
  automl_values = create_automl_values(global_values)

  final_values = {**tibero_values, **nginx_values, **hyperdata_values, **automl_values}
  with open("values.yaml", "w") as f:
    yaml.safe_dump(final_values, f)



