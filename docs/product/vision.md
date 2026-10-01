# Visão do produto — Bipolaris

## Propósito

Um diário privado em que a pessoa registra gastos e, se desejar, descreve seu estado emocional, motivação e reflexão. O app mostra o que a própria pessoa anotou sem explicar clinicamente os motivos ou dizer que o estado causou a compra. Estudos qualitativos recentes destacam autonomia, preferências e riscos percebidos como temas relevantes no desenho de autorregistro (Astill Wright et al., 2025; Michalak et al., 2025).

## Objetivo do MVP

Implementar um fluxo funcional, local e controlado pela pessoa para cadastrar, consultar, editar, apagar e exportar gastos com reflexão opcional, em Flutter para Android e Web/Wasm.

## Dentro do escopo

- Cofre local cifrado por senha; a senha não é armazenada.
- Gasto com valor BRL, categoria, data, estado planejado/não planejado e descrição opcional.
- Texto livre opcional para estado autodescrito, motivação e reflexão.
- Linha do tempo, total registrado e somas descritivas por estado informado.
- Bloqueio, exclusão individual, exclusão total e exportação JSON explícita.
- Avisos sobre armazenamento local, perda de senha, limites da cifra e exportação sem cifra.

## Fora do escopo

- Diagnóstico, previsão de episódios, triagem, pontuação de risco ou alerta clínico.
- Conselho médico, financeiro, terapêutico ou de medicação.
- Relações causais, inferências de estado ou linguagem culpabilizante.
- Conta, servidor, sincronização, importação bancária, analytics, publicidade, IA ou compartilhamento automático.
- Alegações de conformidade legal, eficácia ou validação clínica.

## Critérios de aceite

1. Primeira execução permite criar senha; depois o conteúdo só aparece após desbloqueio.
2. Registros são cifrados em repouso e texto reflexivo não aparece na preferência armazenada.
3. Criar, editar, remover e consultar registros funciona após recarregar e desbloquear.
4. Reflexão, estado e motivação podem ficar vazios.
5. Valores não positivos ou inválidos são rejeitados e BRL é exibido corretamente.
6. Resumos mostram totais e contagens sem afirmar causa ou diagnóstico.
7. Exportação avisa que o JSON é legível; exclusão total exige confirmação.
8. Testes, builds Web/Wasm e Android passam.
9. Interface/documentação explicam perda de senha, armazenamento local, exportação e ausência de sincronização.

## Estado de evidência

Testes de software não demonstram eficácia, utilidade clínica, comportamento financeiro típico ou adequação a pacientes. Estudos com participantes são trabalho futuro sujeito a protocolo, governança e revisão ética aplicáveis.
