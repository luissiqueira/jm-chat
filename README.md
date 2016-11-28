# jm-chat
Um simples chat em rede utilizando shell script.

## Motivação

Trabalho final da disciplina de Programação em Shell Script do curso de
Redes de Computadores da Universidade Federal do Ceará – Campus de Quixadá, turma 2016.2.

## Iniciar o server

Para iniciar o servidor é necessário possuir o subpacote **ncat** presente
no pacote do **[nmap](https://nmap.org/man/pt_BR/)**.

O usuário que dará início ao server deverá ter permissão de escrever na própria pasta
onde o script está localizado e na pasta **/tmp**.

Uma vez que os requisitos acima estejam satisfeitos, basta executar o script
 *server.sh*.

## Conectar como cliente

Para iniciar conexão o cliente deverá ter acesso via rede a máquina que iniciou o server.
 
Pode ser utilizado o comando **nc** ou o próprio **ncat** para realizar a conexão.

Exemplo de conexão com **nc**:
- nc 192.168.10.25 8080

Exemplo de conexão com **ncat**:
- ncat 192.168.10.25 8080

Nesses exemplos o ip 192.168.10.25 é o ip da máquina onde o server está rodando e 8080 é a porta padrão para o chat.

## Contribuidores

Francisco Jocélio Teixeira Silva
[Luis Siqueira de Andrade Júnior](https://github.com/luissiqueira)
[Heli Silva Amaral](https://github.com/heliamaral)
[Ueliton Sousa Dodó](https://github.com/uelitonsd)