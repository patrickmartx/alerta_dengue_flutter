const LISTAR_ESTADOS_URL = 'https://brasilapi.com.br/api/ibge/uf/v1';

// LISTAR_MUNICIPIOS_URL(int codigo) {
//   return "https://brasilapi.com.br/api/ibge/municipios/v1/$codigo";
// }

LISTAR_MUNICIPIOS_URL(String sigla) {
  return "https://brasilapi.com.br/api/ibge/municipios/v1/$sigla";
}

const ALERTADENGUE_BASE_URL = "https://info.dengue.mat.br/api/alertcity/?";