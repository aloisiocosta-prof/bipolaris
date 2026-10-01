# Roteiro acadêmico — bipolaris

## Situação e limite
O README descreve software para acompanhamento terapêutico de pessoas com transtorno bipolar, mas a árvore atual tem poucos arquivos. Isso não demonstra eficácia clínica, segurança terapêutica nem validação com pacientes; o roteiro restringe-se à engenharia de software.

## Problema e objeto candidatos
Problema: requisitos, modelo de dados, papéis, fluxos, controles de privacidade e avaliação ainda não estão delimitados.
Objeto: arquitetura/protótipo de acompanhamento, avaliado inicialmente apenas com dados sintéticos.
Pergunta candidata: quais requisitos verificáveis de privacidade, controle de acesso, integridade e recuperação devem ser definidos e testados sem dados reais?

## Objetivo e etapas
Definir e avaliar requisitos de qualidade para protótipo com cenários sintéticos.
1. Especificar finalidade, limites de uso e requisitos com supervisão institucional e profissional competente.
2. Modelar ameaças, minimização de dados, acesso, retenção e recuperação.
3. Criar dados sintéticos que não reproduzam pessoas reais.
4. Testar requisitos técnicos e acessibilidade com fixtures sintéticas.
5. Antes de qualquer estudo com pessoas ou dados reais, submeter protocolo à avaliação ética e governança institucional apropriadas.
6. Publicar apenas artefatos compatíveis com permissões, privacidade e regras institucionais.

## Método e literatura
Estudo de engenharia de artefato com requisitos, modelagem de ameaças e testes sintéticos; não medir desfechos de saúde nem alegar benefício terapêutico. Revisar software de saúde digital, privacidade/segurança, acessibilidade e avaliação de software de saúde.

## Comunicação
Primeira saída possível: relatório de arquitetura/validação sintética com limites de uso explícitos. Pôster deve declarar artefato experimental e ausência de dados clínicos.

## Gate
Bloqueado para dados humanos/de saúde ou alegações clínicas até haver governança e avaliação ética adequadas. Nunca versionar prontuários, relatos identificáveis, credenciais ou dados de pacientes no repositório público.