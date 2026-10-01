# Modelo inicial de ameaças

## Ativos a proteger se dados reais forem introduzidos
Texto pessoal, saúde mental, identidade, credenciais, consentimentos, conteúdo compartilhado, metadados e chaves. Dados de saúde são sensíveis e requerem finalidade, base legal e controles específicos.

## Atores e ameaças
- Pessoa curiosa abre a demonstração e insere dados reais apesar do aviso.
- Extensão, script de terceiros, dependência ou cadeia de build tenta exfiltrar conteúdo.
- Prompt injection em texto citado tenta mudar política ou extrair dados.
- Provedor de modelo registra ou reutiliza conteúdo inesperadamente.
- Conta compartilhada, dispositivo perdido, backup ou exportação expõe material.
- Agente alucina, rotula sentimento como diagnóstico ou produz orientação clínica indevida.
- Saída generativa ou treinamento amplifica vieses de linguagem/experiência.

## Controles no protótipo
Sem campos de entrada, armazenamento, rede, modelos, métricas ou segredos. Usar apenas fixtures sintéticas. CI com permissões mínimas de leitura.

## Controles necessários antes de persistência/IA
Inventário e fluxo de dados, avaliação de impacto à proteção de dados, threat modeling atualizado, gestão de segredos, criptografia, autorização, retenção e eliminação testáveis, segurança de dependências, resposta a incidentes, auditoria e teste de backup/exportação.

## Gate
Não colocar dados reais ou de participantes neste repositório público. Qualquer coleta acadêmica exige protocolo aprovado, consentimento e regras de armazenamento/compartilhamento autorizadas. Fazer revisão jurídica/regulatória e de segurança antes de produção.
