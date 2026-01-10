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

    System.assertNotEquals(null, resultado);
    System.assertEquals('01001-000', resultado.cep);
    System.assertEquals('Praça da Sé', resultado.logradouro);
    System.assertEquals('Sé', resultado.bairro);
    System.assertEquals('São Paulo', resultado.localidade);
    System.assertEquals('SP', resultado.uf);
  }

  @isTest
  static void testBlankGetAddressFromCep() {
    // Testar CEP vazio
    try {
      CepService.getAddressFromCep('');
      System.assert(false, 'Esperava uma exceção');
    } catch (AuraHandledException e) {
      System.assertEquals('CEP inválido', e.getMessage());
    }
  }

  @isTest
  static void testInvalidCepFormatGetAddressFromCep() {
    try {
      CepService.getAddressFromCep('123');
      System.assert(false, 'Esperava uma exceção');
    } catch (AuraHandledException e) {
      System.assertEquals('CEP deve conter 8 dígitos', e.getMessage());
    }
  }
}
