import { LightningElement } from "lwc";
import getAddressFromCep from "@salesforce/apex/CepService.getAddressFromCep";
import { NavigationMixin } from "lightning/navigation";

export default class CepLookup extends NavigationMixin(LightningElement) {
  cep = "";
  logradouro = "";
  bairro = "";
  localidade = "";
  uf = "";

  error = null;
  localEncontrado = false;

  handleCepChange(event) {
    this.cep = event.target.value;
    this.localEncontrado = false;
    this.error = null;
  }

  async handleSearch() {
    console.log("handleSearch executado");
    this.localEncontrado = false;
    this.error = null;

    try {
      const resultado = await getAddressFromCep({ cep: this.cep });
      console.log("Resultado LWC:", JSON.stringify(resultado));
      this.logradouro = resultado.logradouro;
      this.bairro = resultado.bairro;
      this.localidade = resultado.localidade;
      this.uf = resultado.uf;
      this.localEncontrado = true;
    } catch {
      this.error = "Erro ao buscar o CEP ou CEP inválido.";
    }
  }

  handleCreateRecord() {
    const fields = {
      CEP__c: this.cep,
      Street__c: this.logradouro,
      Neighborhood__c: this.bairro,
      City__c: this.localidade,
      State__c: this.uf
    };
    this[NavigationMixin.Navigate]({
      type: "standard__objectPage",
      attributes: {
        objectApiName: "AddressBR__c",
        actionName: "new"
      },
      state: {
        defaultFieldValues: Object.entries(fields)
          .map(([key, value]) => `${key}=${value}`)
          .join(",")
      }
    });
  }
}
