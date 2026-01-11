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

## Documentação oficial

- [HttpCalloutMock – Apex Reference](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref./apex_interface_httpcalloutmock.htm)
- [Retornando erros em Apex para LWC/Aura](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/controllers_server_apex_custom_errors.htm)
- [Named Credentials – Guia oficial](https://developer.salesforce.com/docs/platform/named-credentials/guide/get-started.html)
- [Invoking HTTP Callouts -  Como fazer chamadas HTTP em Apex](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http.htm)
- [Mock de Callout – Conceitos gerais](https://apexprimer.com/apex-mock-testing)

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

## CEP Lookup – Imagens de funcionamento

<img width="702" height="1586" alt="cep_lookup_flow" src="https://github.com/user-attachments/assets/999691b3-ec6a-4a0b-af39-ba3fc24bae9a" />

