//ignore_for_file: constant_identifier_names

// CLASSE DE ROTAS QUE DECLARAM TODAS AS ROTAS DO PROJETO
class Routes {
  static const HOME = '/';
  static const LOGIN_PAGE = '/login';
  static const FORGET_PASSWORD = '/forget_password';
  static const WORKSPACE = '/workspace';
  static const DOMAIN_ACCOUNTS = '/empresas';
  static const PIX = '/pix';
  static const HISTORICO = '/historico_transacoes';
  static const TRANSACAO_CONTA = '/transacoes_entre_contas';
  static const USERS = '/users';
  static const DOMAINS = '/domains';
  static const APPLICATIONS = '/applications';
  static const ROUTES = '/routes';
  static const ROLES = '/roles';
}

// CLASSE DE CONTANTS QUE DECLARAM TODAS AS VARIAVEIS COMUMENTE USADAS NO PROJETO
class Constants {
  static const APP_NAME = 'ViggoPay Admin';
}

class AppStateConst {
  static const LOGGED = 'LOGGED';
  static const NOT_LOGGED = 'NOT_LOGGED';
  static const ACTIVE = 'ACTIVE';
}
