const LISTAR_ESTADOS_URL = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados';

LISTAR_MUNICIPIOS_URL(int codigo) {
  return "https://servicodados.ibge.gov.br/api/v1/localidades/estados/$codigo/municipios";
}

const ALERTADENGUE_BASE_URL = "https://info.dengue.mat.br/api/alertcity/?";