# CepService — Consulta de CEP com Apex e ViaCEP

Este repositório contém um serviço Apex para consulta de endereços brasileiros usando a API pública do ViaCEP.

O foco do projeto é mostrar uma integração externa simples em Apex, com tratamento de erros explícito e testes unitários bem isolados usando mock de callout HTTP.

É um projeto pequeno, mas pensado para ser fácil de entender, testar e evoluir.

## O que o serviço faz
O fluxo do serviço é o seguinte:

1. Recebe um CEP como String
2. Remove qualquer caractere que não seja numérico
3. Valida se o CEP possui exatamente 8 dígitos
4. Realiza o callout HTTP para o ViaCEP
5. Trata alguns cenários comuns de erro:
   - CEP inexistente (retorno com "erro": true)
   - Status HTTP diferente de 200
   - JSON malformado ou inesperado
6. Retorna um objeto tipado (CepResponse) com os dados do endereço

Quando ocorre qualquer erro, a exceção é lançada usando **AuraHandledException**, facilitando o consumo em LWC ou Aura.

## Estrutura do projeto

1. CepService.cls
2. CepServiceHttpMock.cls
3. CepServiceTest.cls

### CepService.cls

Classe principal do serviço.  
Responsável por:

- Validar e normalizar o CEP
- Montar e executar o callout
- Interpretar a resposta da API
- Centralizar o tratamento de erros

A ideia foi manter toda a lógica de integração concentrada em um único lugar.

### CepServiceHttpMock.cls

Mock de callout HTTP utilizado nos testes.

Simula diferentes respostas do ViaCEP, incluindo:

- CEP válido
- CEP inexistente
- Erro HTTP 500
- JSON malformado
- Cenário padrão

Isso garante que os testes não dependam de chamadas externas reais.

### CepServiceTest.cls

Classe de testes unitários cobrindo:

- Consulta de CEP com sucesso
- CEP vazio ou inválido
- Tratamento de respostas de erro da API

Os testes foram escritos pensando em previsibilidade e cobertura dos principais fluxos do serviço.
