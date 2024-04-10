
# How to run the assignment 



1. Open this assignment in github code space.
2. Run these commands in github code spaces terminal.


```
$ minikube start
```

``` 
$ minikube addons enable ingress
```


In your code space navigate to assignment 3 directory 

```
$ cd /your/path/to/assignment3
```

## First Load balancer  :
### Run these commands : 

``` 
$ kubectl apply -f nginx-configmap.yaml  -f app-1-svc.yaml -f app-2-svc.yaml -f nginx-svc.yaml -f app-1-dep.yaml -f app-2-dep.yaml -f nginx-dep.yaml
```

```
$ kubectl apply -f nginx-ingress.yaml
```

### Test your setup 

```
$ kubectl get deployments


NAME        READY   UP-TO-DATE   AVAILABLE   AGE
app-1       3/3     3            3           2m57s
app-2       1/1     1            1           2m57s
nginx-dep   5/5     5            5           2m57s

```
Wait a few seconds for pods to be up and scheduled.




```
$ kubectl get services
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
app-1-service   ClusterIP   10.106.92.114    <none>        8080/TCP   19s
app-2-service   ClusterIP   10.104.108.72    <none>        8080/TCP   19s
kubernetes      ClusterIP   10.96.0.1        <none>        443/TCP    54s
nginx-svc       ClusterIP   10.101.209.124   <none>        80/TCP     19s
```



```
$ kubectl get ingress
NAME            CLASS   HOSTS   ADDRESS        PORTS   AGE
nginx-ingress   nginx   *       192.168.49.2   80      2m38s
```

If it does not match the expected output make sure you have all files in directory, wait few seconds for pod to be scheduled and up , with minikube setup. Re do the steps.

### Finally test load balancer

Get the ip for your minikube 

```
$ minikube ip
``` 
Run this multiple times to see Load balancing between servers
```
$ curl http://$(minikube ip)/
```


my output, yours should look something like this with even load balancing.


```
@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl http://192.168.49.2/
Hello World from [app-1-69f7655c4-67lmv]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl http://192.168.49.2/
Hello World from [app-2-65df847b85-js7wl]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl http://192.168.49.2/
Hello World from [app-1-69f7655c4-67lmv]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl http://192.168.49.2/
Hello World from [app-2-65df847b85-js7wl]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ 
```
## Now to test Canary Deployment


Now run this command:

To avoid running into errors with canary deployment that uses same url for its ingress, delete the previous nginx-ingress.

```

$ kubectl delete ingress nginx-ingress

```

```
$ kubectl apply -f app-1-ingress.yaml -f app-2-ingress.yaml

```
Check if ingresses are created:
```
$ kubectl get ingress
```

You should see something like this:

```
NAME            CLASS   HOSTS   ADDRESS        PORTS   AGE
app-1-ingress   nginx   *                      80      6s
app-2-ingress   nginx   *                      80      6s
nginx-ingress   nginx   *       192.168.49.2   80      2m33s

```

Get MiniKube Ip for next step:

```
$ minikube ip
```

Now run this command multiple time to see 30% of requests directed towards app2 and 70% to app1

```
$ curl -kL http://$(minikube ip)/
```
You should see something like this 


``` 

@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-1-69f7655c4-t7xqs]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-2-65df847b85-js7wl]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-1-69f7655c4-67lmv]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-1-69f7655c4-d49rv]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-1-69f7655c4-t7xqs]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-1-69f7655c4-67lmv]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-1-69f7655c4-t7xqs]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-2-65df847b85-js7wl]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-1-69f7655c4-67lmv]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-2-65df847b85-js7wl]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-1-69f7655c4-d49rv]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-1-69f7655c4-d49rv]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ curl -kl  http://192.168.49.2/app
Hello World from [app-1-69f7655c4-t7xqs]!@QaziSaboorr ➜ /workspaces/test-assignment3 (main) $ 
```


## END OF ASSIGNMENT