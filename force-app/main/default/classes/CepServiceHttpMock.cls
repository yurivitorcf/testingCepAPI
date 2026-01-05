@isTest
global class CepServiceHttpMock implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest request) {
    HttpResponse res = new HttpResponse();

    String endpoint = request.getEndpoint();

    //cep valido do ViaCEP
    if (endpoint.contains('/01001000/')) {
      res.setStatusCode(200);
      res.setBody(
        '{"cep":"01001-000","logradouro":"Praça da Sé","bairro":"Sé","localidade":"São Paulo","uf":"SP"}'
      );
      //cep não encontrado
    } else if (endpoint.contains('/00000000/')) {
      res.setStatusCode(200);
      res.setBody('{"erro": true}');
      //cep com erro de servidor
    } else if (endpoint.contains('/10000000/')) {
      res.setStatusCode(500);
      res.setBody('Erro de servidor');
      //cep com formato json invalido/ mal formatado
    } else if (endpoint.contains('/123456789/')) {
      res.setStatusCode(200);
      res.setBody('formato inválido');
    }
    //retorna qualquer outro cep como valido
    else {
      res.setStatusCode(200);
      res.setBody(
        '{"cep":"77777777","logradouro":"rua a","bairro":"bairro b","localidade":"cidade c","uf":"dd"}'
      );
    }
    return res;
  }
}
