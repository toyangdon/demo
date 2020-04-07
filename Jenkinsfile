def POD_LABEL = "java-builder"
podTemplate(label: POD_LABEL, cloud: 'kubernetes', containers: [
    containerTemplate(name: 'jnlp', image: 'toyangdon/jnlp-slave-arm64:4.3-1')
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), //实现dockerInDocker
    hostPathVolume(mountPath: '/usr/local/sbin', hostPath: '/opt/k8s/bin')  //使用宿主机的docker\kubectl等二进制文件
  ]
  ) {

    node(POD_LABEL) {
       stage('下载代码') {
            git  ’https://github.com/toyangdon/demo.git'
        }
	   stage('构建镜像'){	
			dir("demo"){
			  docker build -t  toyangdon/demo:${BUILD_ID} .
			}
		}
		stage('推送镜像'){	
			 withCredentials([usernamePassword(credentialsId: 'docker_hub', passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
				docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
				docker push toyangdon/demo:${BUILD_ID}
			}
		}
		stage('部署服务'){
			withKubeConfig( credentialsId: 'kubernetes-builder') {
				dir(kustomize/base/overlays/dev){
					kustomize edit set image toyangdon/demo:${BUILD_ID}
					kustomize build |kubectl apply -f -
				}
			}
		}
    }
}