# lexical-analyzer
Trabalho Tradutores GA - 2021/2 - Analisador Léxico utilizando JFLEX

## Pré-requisitos
- JDK 8
- JFLEX 1.8.2

OBS: As variáveis de ambiente devem estar configuradas corretamente.

## Como executar
```bash
# clonar repositório
git clone https://github.com/ViegasPedro/lexical-analyzer.git

# entrar na pasta do projeto
cd lexical-analyzer

# criar o analisador pelo jflex
jflex Lexer.flex

# compilar o analisador
javac analyzer.java

# executar o analisador para o arquivo code.txt
java analyzer code.txt
```
