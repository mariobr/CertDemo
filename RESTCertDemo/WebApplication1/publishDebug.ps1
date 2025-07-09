$param1=$args[0]


dotnet publish -c Debug   --framework net9.0
docker build -t mariobr/certdemo:1 -f .


if ($param1 -eq "push") {
	docker push mariobr/certdemo:1
}


