# Teste para vaga Backend - Inovamind

Este teste tem como tarefa a criação de um web crawler para realizar a busca de frases no site http://quotes.toscrape.com/.
A aplicação deve receber a tag como parâmetro e, baseando-se nessa tag, buscar frases que estejam classificadas de acordo com essa tag.

## Tecnologias utilizadas

|Software | Versão|
|--------|-----------|
| Ubuntu | 20.04.4 LTS |
| Ruby  | 3.0.0 |
| Rails | 7.0.2.2 |
| MongoDB | 5.0.6 |

## Preparação do ambiente

Para utilizar a aplicação, devemos realizar a instalação dos componentes acima. Após a instalação, iremos iniciar o serviço de banco de dados e habilitar sua inicialização (opcional).

    > systemctl start mongod
    > systemctl enable mongod (OPCIONAL)

Após a inicialização do serviço, podemos baixar a aplicação e começar a utilizar. 

## Executando a aplicação

Após baixada, execute o terminal no diretório onde se localiza a aplicação e execute os seguintes comandos:

    Instalar GEMs necessárias para o funcionamento da aplicação:
    > bundle install

    Iniciar o serviço:
    > rails s

Feito isso, a aplicação já pode ser utilizada. 

## Criando requisições via PostMan

Para criarmos as requisições, precisamos realizar as seguintes configurações:

    Tipo de requisição: GET
    Link da requisição: http://localhost:3000/quotes/<TAG>
    
    Realizar a configuração do token de acesso:
    Aba Headers, incluir a linha:
    Key: Authorization - Value: Token inovamind

CÓDIGOS DE RETORNO:

| Código | Descrição |
|--------|-----------|
| 200 | É recebido caso a requisição possua dados válidos |
| 204  | É recebido caso não exista nenhum cadastro no BD e/ou site com a tag solicitada |

