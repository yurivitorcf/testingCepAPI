public with sharing class CepService {
  public class CepResponse {
    @AuraEnabled
    public String cep;
    @AuraEnabled
    public String logradouro;
    @AuraEnabled
    public String bairro;
    @AuraEnabled
    public String localidade;
    @AuraEnabled
    public String uf;
  }

  @AuraEnabled
  public static CepResponse getAddressFromCep(String cep) {
    if (String.isBlank(cep)) {
      throw new AuraHandledException('CEP inválido');
    }

    //remover caracteres não numéricos
    cep = cep.replaceAll('[^0-9]', '');

    if (cep.length() != 8) {
      throw new AuraHandledException('CEP deve conter 8 dígitos');
    }

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:ViaCEP/ws/' + cep + '/json/');
    request.setMethod('GET');
    HttpResponse response;

    try {
      response = http.send(request);
    } catch (Exception e) {
      throw new AuraHandledException(
        'Erro ao conectar ao serviço: ' + e.getMessage()
      );
    }
    if (response.getStatusCode() != 200) {
      throw new AuraHandledException(
        'Erro ao buscar CEP: ' + response.getStatus()
      );
    }

    //armazenar a resposta em um objeto CepResponse
    CepResponse cepResponse;

    try {
      cepResponse = (CepResponse) JSON.deserialize(
        response.getBody(),
        CepResponse.class
      );
    } catch (Exception e) {
      throw new AuraHandledException(
        'Erro na resposta do serviço: ' + e.getMessage()
      );
    }
    if (cepResponse == null) {
      throw new AuraHandledException('CEP não encontrado');
    }
    return cepResponse;
  }
}
