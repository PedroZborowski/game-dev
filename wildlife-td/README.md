# Wildlife Tower Defense

_Um jogo de Tower Defense complexo desenvolvido em equipe no Roblox Studio, com foco em networking, persistência de dados e IA avançada._

![GIF ou Screenshot do Jogo](https://github.com/PedroZborowski/game-dev/blob/main/wildlife-td/images/tiger.gif?raw=true)
![GIF ou Screenshot do Jogo](https://github.com/PedroZborowski/game-dev/blob/main/wildlife-td/images/inventory.png?raw=true)
![GIF ou Screenshot do Jogo](https://github.com/PedroZborowski/game-dev/blob/main/wildlife-td/images/game.png?raw=true)

## Sobre o Projeto

"Wildlife Tower Defense" foi meu segundo projeto de jogo e representa um salto significativo em complexidade, escopo e colaboração em comparação com meu primeiro trabalho. Desenvolvido em um grupo maior de pessoas na plataforma Roblox Studio, este projeto me expôs a desafios reais do desenvolvimento de jogos multiplayer online.

O objetivo era criar uma experiência de Tower Defense completa, com múltiplos tipos de inimigos e torres, sistemas de progressão e salvamento de dados, tudo funcionando em um ambiente cliente-servidor.

### Status do Projeto: Descontinuado

Infelizmente, o desenvolvimento do jogo foi descontinuado. Com o tempo, o grupo inicial de desenvolvedores diminuiu, o que tornou o escopo ambicioso do projeto inviável de ser concluído no tempo planejado. Apesar disso, o projeto foi uma experiência de aprendizado imensurável sobre os desafios do desenvolvimento em equipe e o gerenciamento de escopo.

## Minha Contribuição como Líder de Desenvolvimento

Neste projeto, atuei como **Líder de Desenvolvimento (Dev Lead)**. Além de programar funcionalidades específicas, minha principal responsabilidade era a gestão técnica da equipe para garantir a coesão, a qualidade e a integração do código. Minhas tarefas incluíam:

-   **Gerenciamento de Contribuições:** Organizar, revisar (code review) e integrar as contribuições de código de quase **10 desenvolvedores diferentes**. Isso exigiu um profundo entendimento de cada parte do projeto para garantir que as novas funcionalidades se encaixassem corretamente na arquitetura existente.
-   **Arquitetura de Código:** Definir a estrutura base do projeto e as boas práticas a serem seguidas, permitindo que diferentes sistemas (IA, UI, salvamento de dados, etc.) pudessem coexistir sem conflitos.
-   **Resolução de Conflitos:** Mediar e resolver conflitos de código (`code conflicts`) que surgiam da integração do trabalho de múltiplos programadores, garantindo a estabilidade do projeto.
-   **Desenvolvimento Direto:** Além da gestão, também fui o principal responsável pela implementação de diversas funcionalidades da parte funcional do jogo, com destaque às citadas na seção abaixo.

## Desafios Técnicos do Projeto

Este projeto foi uma imersão em problemas complexos de engenharia de software. Alguns dos principais desafios que a equipe enfrentou foram:

-   **Interação Cliente-Servidor:** Garantir que a lógica do jogo fosse segura e sincronizada entre o servidor e múltiplos clientes, utilizando a arquitetura de rede do Roblox (`RemoteEvents` e `RemoteFunctions`).
-   **Persistência de Dados:** Implementar um sistema robusto com `DataStoreService` para salvar o progresso dos jogadores de forma segura.
-   **Aplicação de Álgebra Linear:** Utilizar vetores e cálculos de trajetória para a mira das torres, o movimento dos inimigos e os ataques em área.
-   **Inteligência Artificial Robusta:** Criar múltiplos comportamentos para inimigos e torres, com lógica de prioridade de alvos e habilidades especiais.

## Tecnologias Utilizadas

-   **Plataforma:** Roblox Studio
-   **Linguagem:** Luau
