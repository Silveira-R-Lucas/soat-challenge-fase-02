Olá ! Este é o repositório da solução em rails para o soat-challenge-fase-01

link do repositório:
https://github.com/Silveira-R-Lucas/soat-challenge-fase-01

abrir o arquivo do event storming com a plataforma excalidraw:

excalidraw.com

1- Para executar esta solução você deve ter o docker instalado:

https://docs.docker.com/engine/install/

2- Adicionar um arquivo .env na pasta raíz do projeto com as variáveis de ambientes de acesso ao postgres

ex:

POSTGRES_USER=example-user \
POSTGRES_PASSWORD=shiiiiiiiitsscret \
POSTGRES_DB=myapp_development \
DATABASE_URL=postgres://postgres:yourpassword@db:5432/myapp_development \
SECRET_KEY_BASE=$(rails secret) \


3- Para gerar uma imagem docker e rodar a aplicação localmente clone este repositório, entre na pasta raíz do projeto e rode:

docker-compose build
docker-compose up

4 - para verificar se a aplicação está up podemos acessar pelo navegador:

localhost:3000

drive do video com a demonstração:

https://drive.google.com/file/d/1Axo7l0d5KVhthvMgz6c4PLCLxF7u_qrc/view?usp=drive_link

Testando as API'S

para acessar a documentação das api's, acesse a url:

http://0.0.0.0:3000/api-docs

Para o meu teste dos endpoints vou utilizar o curl, configurei a aplicação para que identifique os carrinhos e usuários pela sessão que estão utilizando e para validar essa funcionalidade pelo curl vamos utilizar:

 "curl -c cookies.txt " pra salvar os cookies
  
 "curl -b cookies.txt" pra utilizar os cookies salvos

Buscando o carrinho :

curl -X 'GET' \
  'http://localhost:3000/api/v1/cart/' \
  -H 'accept: application/json' |  python3 -m json.tool
  
Confirmado um id de carrinho diferente:

  curl -c cookies.txt -X 'GET' \
  'http://localhost:3000/api/v1/cart/' \
  -H 'accept: application/json' |  python3 -m json.tool
  
listar pedidos que já realizaram checkout

  curl -X 'GET' \
  'http://localhost:3000/api/v1/cart/list_checked_out_orders' \
  -H 'accept: application/json' |  python3 -m json.tool

listar pedidos que realizaram checkout e não estão finalizados

  curl -X 'GET' \
  'http://localhost:3000/api/v1/cart/list_in_progress_orders' \
  -H 'accept: application/json' |  python3 -m json.tool
  
Registrando nosso cadastro:

curl -b cookies.txt -X 'POST' \
  'http://localhost:3000/api/v1/register' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "cpf": "44536916006",
  "name": "Lucas Silveira",
  "email": "lucas.teste@gmail.com"
}' |  python3 -m json.tool

identificando nossa sessão:

curl -b cookies.txt -X 'POST' \
  'http://localhost:3000/api/v1/sign_in' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "cpf": "44536916006"
}' |  python3 -m json.tool

listar produtos por categoria:

curl -b cookies.txt X 'GET' \
  'http://localhost:3000/api/v1/products_by_category/Lanches' \
  -H 'accept: application/json' |  python3 -m json.tool
  
editar preço do produto:

curl -b cookies.txt -X 'POST' \
  'http://localhost:3000/api/v1/update_product/23' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "price": 2.00
}' |  python3 -m json.tool

adicionar produto no carrinho:

curl -b cookies.txt -X 'POST' \
  'http://localhost:3000/api/v1/cart/' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "quantity": 3,
  "product_id": 12
}'  |  python3 -m json.tool


deletar um produto do carrinho:

curl -X 'DELETE' \
  'http://localhost:3000/api/v1/cart/12' \
  -H 'accept: application/json' |  python3 -m json.tool

Fazer checkout:

curl -b cookies.txt  -X 'POST' \
  'http://localhost:3000/api/v1/cart/12/checkout' \
  -H 'accept: application/json' |  python3 -m json.tool
