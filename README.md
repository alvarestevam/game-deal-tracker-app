# GamesInDeal App

Aplicativo móvel agregador de ofertas de jogos, permitindo aos usuários acompanhar promoções em diversas lojas e realizar auditorias de preços em tempo real.

## Descrição

O **GamesInDeal App** é uma ferramenta indispensável para gamers que desejam economizar. Ele consolida ofertas de múltiplas plataformas, apresenta detalhes de preços históricos e facilita a visualização de jogos gratuitos e promoções atuais.

## Arquitetura e Gerenciamento de Estado

O projeto segue as melhores práticas de desenvolvimento Flutter:
- **Gerenciamento de Estado:** Utiliza o pacote [Provider](https://pub.dev/packages/provider) para uma gestão reativa e eficiente do estado da aplicação.
- **Consumo de API:** Utiliza o [Dio](https://pub.dev/packages/dio) como cliente HTTP, configurado com interceptores e tratamentos de erro padronizados.
- **Arquitetura:** Organizada em camadas (models, services, providers, views, widgets) para garantir manutenibilidade e escalabilidade.

## Estrutura de Modelos

A aplicação utiliza uma estrutura de dados 1:N (Um para Muitos) para representar os jogos e suas respectivas ofertas:

- **GameModel:** Representa os metadados do jogo, como título, plataforma, imagem de capa e data de atualização.
- **GameOffer:** Cada `GameModel` contém uma lista de `GameOffer`, que detalha o preço atual, menor preço histórico, preço final estimado e o link direto para a loja.

## Como Rodar

Para executar o projeto localmente, certifique-se de ter o Flutter instalado em sua máquina e siga os passos abaixo:

1.  **Clonar o repositório:**
    ```bash
    git clone <url-do-repositorio>
    ```

2.  **Instalar as dependências:**
    ```bash
    flutter pub get
    ```

3.  **Executar o aplicativo:**
    ```bash
    flutter run
    ```

---
*Desenvolvido com ❤️ para a comunidade gamer.*
