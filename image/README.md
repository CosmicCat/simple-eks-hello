# Docker

Steps for testing and building the hello world image for this project.

## Testing/Devving the HTML - localhost:8080

```
docker run -p 8080:80 -v $(pwd):/usr/share/nginx/html nginx
```

## Build

```
docker build -t cosmiccat/simple-eks-hello:latest .
```

## Image Test - localhost:8080

```
docker run -p 8080:80 cosmiccat/simple-eks-hello
```

## Push

```
docker login
docker push cosmiccat/simple-eks-hello
```