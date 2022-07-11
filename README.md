# Quotes Web Crawler

Este README foi escrito para ser guia para a execução desta aplicação passo a passo.
desde o setup inicial ao uso da mesma.

## Ambiente

Para a configuração do ambiente de execução serão necessarias as seguintes dependencias: 

* Ruby 3.0.3

* MongoDB

* Redis

## Setup

Apoś a instalacação das dependencias citadas acima, siga os seguintes passos:

* Clonar o repositorio ou fazer download do codigo fonte.
    > git clone https://github.com/ljnferreira/QuotesWebCrawler.git  
    >ou  
    >  gh repo clone ljnferreira/QuotesWebCrawler

* Navege a seguir ate o diretorio do projeto:
  >cd QuotesWebCrawler

* Instale as dependencias
    >bundle install

* Inicie o serviço do banco de dados:  
  No linux:  
  >systemctl start mongodb.service
  
  Caso queira que ele se inicie junto com o sistema, execute antes:
  >systemctl enable mongodb.service

* Inicie o serviço do cache (Redis):  
  No linux:  
  >systemctl start redis.service

  Caso queira que ele se inicie junto com o sistema, execute antes:
  >systemctl enable redis.service
  
* Execute o seguinte comando para criar os primeiros usuarios do sistema:
  >rake db:seed

* Inicie o serviço:  
  * Para servir somente no localhost
    >rails s
  * Para servir em todas as maquinas da rede
    >rails s --binding=0.0.0.0
  * Para iniciar em uma porta diferente
    >rails s -p \<porta>
  * Para iniciar em uma porta diferente e servir para todas as maquinas com acesso a rede:
    >rails s -p \<porta> --binding=0.0.0.0
  
Ao inicializar o servidor rails o mesmo irá configurar no cache Redis uma tarefa
que será executada a cada 12 horas, atualizando o cache com as quotes já pesquisada
verificando para atualizações.

* Para permitir que essas tarefas sejam executadas é necessário que se inicialize
o serviço do Sidekiq, rodando o seguinte comando em outra janela ou aba do terminal:

  >bundle exec sidekiq

## Utilização

### Autenticação

  Esta API utiliza-se de autenticação via JWT, e algumas rotas são também protegidas por autorização, portanto, o primeiro passo é se autenticar através da rota ***/user_token***.  
  Para facilitar o uso e testes criei uma pasta ***/postman*** no projeto que contem todas as colections de requests de API pre configuradas, bastando nas rotas autenticadas adicionar o token obtido da rota ***/user_token***.  

  O login via rota ***/user_token*** pode ser feito enviando um json no body de uma requisição POST no seguinte formato:  
  
  ```json
    {
      "auth":{
        "email": "test@example.com",
        "password": "fancyPassword"
      }
    }
  ```
  
  Que retornará uma resposta no seguinte formato caso o usuario exista e tenha sido possivel realizar login:
  
  ```json
    {
      "jwt": "ultraFancyAndSecureAndAwesomeJWT-Token"
    }
  ```

  Para saber quais usuários existem inicialmente após o setup do sistema basta abrir o arquivo ***/db/seeds.rb*** na pasta inicial do projeto.  
  
### Consumindo a API
  
#### Rota de usuário

  Esta API possui somente uma unica rota aberta a todos os usuários autenticados ( ***/quotes/:search_tag*** ) que retorna todas as quotes que contem uma determinada tag, e retorna um JSON no seguinte formato:
  
  ```json
    {
      "quotes": [
        {
          "quote": "frase",
          "author": "nome do autor",
          "author_about": "link para o perfil do autor",
          "tags": ["tag1", "tag2"]
        },
        {
          "quote": "frase 2",
          "author": "nome do autor 2",
          "author_about": "link para o perfil do autor 2",
          "tags": ["tag1", "tag2"]
        },
      ]
    }

  ```
  
  Desde que o usuario esteja autenticado.  

#### Rota de admin

  Também existem rotas de administrador, que somente usarios do tipo admin podem acessar, e permitem obter algumas informações sobre o cache. Estando logado como admin as rotas disponiveis são:  

* ***/cache/saved***

* ***/cache/searched***

* ***/cache/clean***

  Que retornam respectivamente os seguintes JSON:

  * ***/cache/saved***
  
    ```json
      {
        "cached_quotes": [
          {
            "author": "autor",
            "author_about": "link para o perfil do autor",
            "quote": "“Frase”",
            "tags": [
                "edison",
                "failure",
                "inspirational",
                "paraphrased"
            ]
          },
          {
            "author": "autor",
            "author_about": "link para o perfil do autor",
            "quote": "“Frase”",
            "tags": [
                "life",
                "love"
            ]
          }
        ]
      }
    ```

  * ***/cache/searched***
  
    ```json
      {
        "searched_tags": [
          {
            "tag": "failure"
          },
          {
            "tag": "love"
          }
        ]
      }
    ```
  
  * ***/cache/clean***
  
    ```json
      {
        "tags_deleted": 2,
        "quotes_deleted": 2
      }
    ```  
  
### Criar novo usuario

  Para criar um novo usuario basta enviar uma chamada POST para a rota ***/users/create*** que com o seguinte body:

  ```json
    {
      "user": {
        "email" : "user@example.com",
        "password": "fancypassword",
        "password_confirmation": "fancypassword",
        "username": "<First Name> <Last Name>",
        "role": "admin" //optional, case null default is 'user'
      }
    }
  ```

  Em caso de sucesso a api retornará o seguinte objeto JSON:  

  ```json
    {
      "status": 200,
      "msg": "User was created."
    }
  
  ```

## Contato

  Caso surjam dúvidas ou sugestões ao fim deste tutorial favor abrir uma issue no projeto ou, caso prefira, entre em contato via ljnferreira@gmail.com.
