# Docker Welt (=Docker World)

The docker-welt command can provides a simple wrapper of docker "build" and "run". The use is very simple. Please put your docker template with Dockerfile into "docker-welt/containers" or "docker-welt/experiments" directory.

* To build a image, run with a name.

     $ docker-welt -b tensorflow
     
     ## This executes the following commands which creates "docker-welt/tensorflow" image.

     cd containers/tensorflow
     docker build -t docker-welt/tensorflow .


* To run the image, run with a name. 

     $ docker-welt -r tensorflow
     
     ## This executes the following commands. It maps X-window and uses workarea/[name]. If need, please put your data to workarea/[name] before the execution. 

     docker run -it --rm --name tensorflow-5129 -h tensorflow-5129 -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix  --volume=$PWD/workarea/tensorflow:/work docker-welt/tensorflow


* Components
 1. Elasticsearch Logstash Kibana (Grafana) stack. Please read a documentation (under [doc](doc)).
 
  $ docker-welt -C -b tier2_ELK

  

 1. Foreman

  * https://www.youtube.com/watch?v=eHjpZr3GB6s&feature=emb_logo


 2. HTCondor
  
  * Building HTCondor (-C = use docker-compose, -b = build)

  $ docker-welt -C -b htcondor
  
  * Running HTCondor master and worker nodes (-C = use docker-compose, -r = run)

  $ docker-welt -C -r htcondor
