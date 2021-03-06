# godot3.2_countdown / [ADDONS]

Um contador básico armazenando o tempo em um arquivo local ou recuperado de um servidor, 
você pode fechar o jogo que o contador continua a contagem.

----------

### Demonstração
- https://www.youtube.com/watch?v=jU3Ihmc3OEE

[![Video com a explicação](https://img.youtube.com/vi/jU3Ihmc3OEE/0.jpg)](https://www.youtube.com/watch?v=jU3Ihmc3OEE)

----------

### Instalação
- Copie a pasta addons para seu projeto ou faça [download do addon "Countdown"](https://github.com/thiagobruno/godot3.2_countdown/raw/master/addons/countdown.zip)
- Acesse as configurações do projeto, e habilite o plugin "Countdown"
- Para usar, adicione um novo node do tipo "Countdown" e coloque suas configurações

----------

#### Você pode definir
- name_countdown - Nome do contador ```string```
- wait_time - Tempo de espera ```HH:MM:SS```, exemplo: ```00:01:00```
- end_label - Label final, você pode mostrar uma mensagem no fim do countdown
- unix_server - Servidor Unix, exemplo: ```https://unixtimestamp.birdy.studio``` o servidor deve retornar um timestamp puro! 
- auto_restart - Auto Reinicialização
- auto_start - Auto inicialização

*O node "countdown" emite um sinal "start" e "finish" e passa como parâmetro o nome do contador "name_countdown"

----------

#### Usando o unix_server
Você pode montar em seu server uma página para retornar uma timestamp unix, veja um exemplo utilizando o PHP

```php
<?php
$date = new DateTime();
echo $date->getTimestamp();
```

----------

#### Exemplos:
- O primeiro parâmetro pode ser o tempo ou null! Se for null, o countdown vai pegar a informação configurada no node
- O segundo parâmetro diz ao contador se ele pode auto-reinicializar ou não, por padrão o valor é "false"


##### Exemplo 1
```
$countdown._start("00:00:15", true) 
```

##### Exemplo 2
```
$countdown._start(null, true) 
```

##### Exemplo 3
```
$countdown._start() 
```

----------

### ...
Vai utilizar esse código de forma comercial? Fique tranquilo pode usar de forma livre e sem precisar mencionar nada, claro que vou ficar contente se pelo menos lembrar da ajuda e compartilhar com os amigos, rs. Caso sinta no coração, considere me pagar um cafezinho :heart: -> https://ko-fi.com/thiagobruno

