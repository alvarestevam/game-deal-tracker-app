# GameDeal Tracker - Mobile App

O **GameDeal Tracker** é um aplicativo móvel desenvolvido em Flutter que atua como cliente para a API de monitoramento de promoções de jogos hospedada em uma infraestrutura própria na nuvem (Oracle VM). O objetivo principal do aplicativo é consolidar e auditar dados de promoções de mais de 20 lojas de jogos de PC em uma interface limpa, intuitiva e de rápida leitura.

---

## 📱 Funcionalidades do Aplicativo

* **Aba Giveaways (Gratuidades):** Listagem em tempo real de jogos e DLCs que estão com 100% de desconto (Steam, Epic Games, GOG, etc.), com redirecionamento direto para a página de resgate.
* **Aba Deals (Promoções):** Feed atualizado com as melhores promoções vigentes, ordenadas de forma inteligente com base no percentual de desconto e no valor final.
* **Aba Auditoria (Search & Audit):** Barra de pesquisa para consultar qualquer jogo específico. O aplicativo exibe o preço atual e valida se ele atingiu o menor valor histórico (*Historical Low*), emitindo um selo visual indicando se é uma oportunidade real de compra.

---

## 🛠️ Stack Tecnológica

* **Framework Mobile:** Flutter (Dart) - para compilação nativa multiplataforma (Android e iOS).
* **Comunicação HTTP:** Biblioteca `dio` para requisições assíncronas e consumo da API RESTful.
* **Gerenciamento de Estado:** `provider` (ou o padrão preferido de injeção de estados).
* **Persistência Local (Opcional para cache):** `shared_preferences`.

---

## 🚀 Arquitetura e Comunicação

O aplicativo consome os seguintes endpoints do nosso backend FastAPI:

1.  `GET /api/v1/giveaways` -> Lista de conteúdos 100% gratuitos.
2.  `GET /api/v1/deals` -> Lista de promoções ordenadas por melhor preço.
3.  `GET /api/v1/games/{title}/audit` -> Auditoria em tempo real cruzando preço atual e menor preço histórico da IsThereAnyDeal (ITAD).

---

## 🤖 Orientações para o Agente Autónomo (Jules)

Se você é o **Jules**, siga as diretrizes abaixo ao criar o código:
1.  **Componentização:** Mantenha a interface separada da lógica de negócios. Organize as pastas em `/lib/views`, `/lib/models`, `/lib/services` e `/lib/widgets`.
2.  **Gerenciamento de Erros:** Certifique-se de que falhas de conexão HTTP (como a API estar fora do ar) exibam um componente visual amigável (ex: *Stateful Widget* de erro com botão de tentar novamente) em vez de travar a tela (*crash*).
3.  **URL Encoding:** Ao chamar a rota de auditoria, garanta que os espaços no nome do jogo sejam convertidos para `%20` (use `Uri.encodeComponent()`).
4.  **Interface Limpa:** Foque em um design focado em leitura ágil, usando componentes como *Cards*, *ListViews* assíncronos (`FutureBuilder`) e indicadores visuais de carregamento (*CircularProgressIndicator*).
