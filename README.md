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