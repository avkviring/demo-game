## Выкладка платформы в kubernetes для локальных тестов

## в 3.7 сломана поддержка oci для зависимостей
## загружаем руками
cd charts
rm -rf *.tgz
rm -rf *.tgz.meta
HELM_EXPERIMENTAL_OCI=1 helm pull oci://docker.registry.cheetah.games/platform --version 1.2.12
cd ../

rm -rf room-config.tgz
tar -czf room-config.tgz -C ../../Matches/Factory/Configuration/ .

helm -n $1 uninstall $1
kubectl delete --namespace $1 --all deployments,statefulsets,services,pods,pvc,pv
helm -n $1 upgrade \
  --install $1 . \
  --set global.grpcDomain=$1.some-domain.com \
  --set global.roomsConfiguration=`cat room-config.tgz |base64`
