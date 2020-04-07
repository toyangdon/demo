def POD_LABEL = "java-builder"
podTemplate(label: POD_LABEL, cloud: 'kubernetes', containers: [
    containerTemplate(name: 'jnlp', image: 'toyangdon/jnlp-slave-arm64:4.3-v1')  
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), //实现dockerInDocker
	persistentVolumeClaim(mountPath: '/root/.m2', claimName: 'jenkins-build-maven-m2'), //如果想避免每次构建重复下载maven依赖包，可以将.m2目录持久化
    hostPathVolume(mountPath: '/usr/local/sbin', hostPath: '/opt/k8s/bin')  //使用宿主机的docker\kubectl等二进制文件
  ]
  ) {

    node(POD_LABEL) {
        stage('下载代码') {
            git  'https://github.com/toyangdon/demo.git'
        }
		stage('编译代码'){	
			 sh 'mvn install'
		}
	   stage('构建镜像'){	
			 sh "docker build -t  toyangdon/demo:${BUILD_ID} ."
		}
		stage('推送镜像'){	
			 withCredentials([usernamePassword(credentialsId: 'docker_hub', passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
				sh "docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}"
				sh "docker push toyangdon/demo:${BUILD_ID}"
			}
		}
		stage('部署服务'){
			withKubeConfig( credentialsId: 'kubernetes-builder') {
				dir(kustomize/base/overlays/dev){
					sh "kustomize edit set image toyangdon/demo:${BUILD_ID}"
					sh "kubectl apply -k -n demo-dev"
				}
			}
		}
    }
}