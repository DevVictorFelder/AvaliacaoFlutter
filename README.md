# Avaliacao Flutter - Posts

Aplicativo Flutter desenvolvido para teste tecnico, com consumo de API, formulario validado, gerenciamento de estado e testes.

## O que foi entregue

- Requisito 1: consumo de `GET https://jsonplaceholder.typicode.com/posts`.
- Requisito 1: listagem exibindo titulo e descricao dos posts.
- Requisito 2: formulario de cadastro com titulo e descricao.
- Requisito 2: validacao de campos obrigatorios e tamanho maximo.
- Requisito 2: envio via `POST https://jsonplaceholder.typicode.com/posts`.
- Requisito 2: novo item refletido imediatamente na listagem.
- Arquitetura MVVM com `ChangeNotifier` e `Provider`.
- Tela de detalhes ao tocar em um item.
- Busca por titulo ou descricao.
- Estados de loading, erro, vazio e sucesso.
- Testes unitarios para model, service, validadores e viewmodels.

## Resultado de qualidade

Validar localmente com Flutter:

```bash
flutter analyze

flutter test
```

## Como rodar

```bash
flutter pub get
flutter run -d chrome
```

Se as pastas de plataforma ainda nao existirem:

```bash
flutter create .
flutter pub get
flutter run -d chrome
```

## API usada

```text
GET  https://jsonplaceholder.typicode.com/posts
POST https://jsonplaceholder.typicode.com/posts
```

Observacao: o JSONPlaceholder e uma API mock. Por isso os titulos e descricoes retornam textos simulados.

## Estrutura

```text
lib/
  core/theme/              Tema visual da aplicacao
  data/models/             Modelos serializaveis
  data/repositories/       Contratos e implementacao de dados
  data/services/           Consumo da API
  presentation/            Views, ViewModels e widgets
```
