@isTest
private class CepServiceTest {
  @isTest
  static void testValidGetAddressFromCep() {
    Test.setMock(HttpCalloutMock.class, new CepServiceHttpMock());

    Test.startTest();
    CepService.CepResponse resultado = CepService.getAddressFromCep(
      '01001-000'
    );
    Test.stopTest();

    System.assetNotEquals(null, resultado);
    System.assertEquals('01001-000', resultado.cep);
    System.assertEquals('Praça da Sé', resultado.logradouro);
    System.assertEquals('Sé', resultado.bairro);
    System.assertEquals('São Paulo', resultado.localidade);
    System.assertEquals('SP', resultado.uf);
  }
}
