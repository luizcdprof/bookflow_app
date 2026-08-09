# 📱 BookFlow App - Semana 15: Componentes Avançados de Interface

## Integração Mobile & Arquitetura Modular

Este projeto consiste na aplicação mobile/web **BookFlow App**, desenvolvida em **Flutter**, com o objetivo de consumir a API RESTful desenvolvida em **Django REST Framework** na disciplina de Desenvolvimento Web.

Na **Semana 15**, focamos na **componentização em Flutter**, no **gerenciamento de estados assíncronos**, no consumo de APIs HTTP e na estruturação do projeto utilizando boas práticas e padrões adotados pelo mercado.

---

## 🏗️ Estrutura de Pastas e Arquitetura

O código foi refatorado e organizado segundo a arquitetura por responsabilidades (Layered Architecture), separando a lógica de negócio, comunicação de rede, modelos de dados e a interface visual (UI):

```text
lib/
├── main.dart                      # Ponto de entrada da aplicação e tema global
├── models/
│   └── healthcheck_model.dart     # Objeto de Transferência de Dados (DTO)
├── services/
│   └── api_service.dart          # Cliente de comunicação HTTP
├── views/
│   └── healthcheck_screen.dart   # Tela e gerenciamento de estado da UI
└── widgets/
    └── custom_status_card.dart    # Componente visual customizado e animado
```

## ⏯️ Execução do código via terminal sem verificação do CORS (para testes)

$ flutter run -d chrome --web-browser-flag "--disable-web-security"

# 📱 BookFlow App - Semana 16: Autenticação JWT, Gestão de Sessão e Interface Adaptativa

Esta documentação detalha a evolução do aplicativo **BookFlow** desenvolvido em **Flutter (Web/Desktop/Mobile)** durante a **Semana 16**.

Nesta etapa, o projeto deixou de ser apenas um visualizador de status (*Healthcheck*) e passou a contar com um **Fluxo de Autenticação Completo via JWT**, consumo de endpoints protegidos com injeção automática de tokens Bearer, tratamento de erros de credenciais e gerenciamento reativo do estado da sessão do usuário.

---

## 🛠️ Tecnologias e Recursos Utilizados

* **`Flutter 3.x`**: Framework de desenvolvimento multiplataforma.
* **`Dart`**: Linguagem de programação reativa e fortemente tipada.
* **`http`**: Pacote oficial para consumo de APIs RESTful e requisições HTTP assíncronas.
* **`Material 3 Design`**: Sistema de design moderno com componentes adaptativos e suporte a temas.

---

## 🏗️ Arquitetura e Estrutura de Pastas

O projeto manteve a arquitetura baseada em camadas (Models, Services, Views e Widgets) para garantir separação de responsabilidades e reutilização de componentes:

```text
bookflow_app/
├── lib/
│   ├── main.dart                 # Gerenciador de rotas reativo e estado raiz
│   ├── models/
│   │   ├── auth_model.dart       # Mapeamento do perfil de Usuário e tokens JWT
│   │   └── healthcheck_model.dart# Mapeamento da resposta de status da API
│   ├── services/
│   │   ├── api_service.dart     # Serviço para chamadas protegidas (Bearer Token)
│   │   └── auth_service.dart    # Comunicação com /auth/login/ e /auth/logout/
│   ├── views/
│   │   ├── healthcheck_screen.dart # Dashboard/Tela interna logada
│   │   └── login_screen.dart    # Tela de Login responsiva e adaptativa
│   └── widgets/
│       ├── custom_status_card.dart # Card de exibição do status da API
│       └── custom_text_field.dart  # Campo de texto customizado com ícones e visibilidade de senha
```