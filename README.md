### Lista de contatos com Flutter em base de dados local
**Instrutor:**<br />
Gabriel Rodrigo Desbesell <br />
<br />

Projeto desenvolvido com os alunos do curso de programação para internet do SENAC SC:

- [x] Apresentação das tecnologias envolvidas e criação das demandas iniciais com estrutura MVC;
- Atualizar o formulário de cadastro:    
    - [x] Adicionar validação do formulário;
    - [x] Adicionar uma foto ao contato;
    - [x] Adicionar latitude e longitude ao contato;
    - [x] Adicionar um link de página web ao contato;
    - [x] Adicionar um email ao contato;
    - [x] Adicionar um telefone ao contato;
    - [x] Ao entrar na tela o primeiro campo deve receber o foco;
    - [x] Cada campo deve permitir inserção de dados apenas do seu tipo;
    - [x] Obrigar o usuário a tirar uma foto;
- Atualizar a lista de contatos:
    - [x] Exibir a foto na listagem(leading,title,subtitle);
    - [x] Remover o botão excluir da Lista;
    - [x] Adicionar menu inferior ao clicar no contato;               
        - [x] Utilizar ícones do FontAwesome;
        - [x] Adicionar opção de alteração do contato;
        - [x] Permitir abrir o link(se cadastrado) do contato no navegador de internet;
        - [x] Abrir compartilhar o contato por WhatsApp;
        - [x] Abrir o telefone no discador;
        - [x] Abrir o e-mail em um aplicativo de e-mail para escrever uma nova mensagem;
        - [x] Permitir excluir o contato;
            - [x] Adicionar confirmação de exclusão;
            - [x] Remover a foto do dispositivo;
        - [x] Adicionar opção de visualização completa do contato:
            - [x] Exibir todos os dados, foto e QRCode do tipo VCard;
        - [x] Exibir opção de ver no mapa a localização do contato(se disponível);
- [x] Adicionar opção no AppBar de leitura de QRCode do tipo VCard e importação do contato para a base de dados;
- [x] Adicionar idiomas(PT e EN) ao app;
- [ ] Adicionar Splash Screen personalizado ao app;
- [ ] Exibir a versão atual do APP na Splash Screen;
- [ ] Atualizar o ícone do aplicativo;
- [x] Modificar o título do aplicativo;

**Corrigir bugs**
- [x] Ao adicionar um contato e apagar ele na sequência não é removido da base de dados, apenas da tela;
- [x] Falha ao exibir o item da lista em modo release(quebrando layout da lista);
  

**Pacotes utilizados no projeto:**
https://pub.dev/packages/get
https://pub.dev/packages/sqflite
https://pub.dev/packages/image_picker
https://pub.dev/packages/url_launcher
https://pub.dev/packages/geolocator
https://pub.dev/packages/qrscan
https://pub.dev/packages/font_awesome_flutter
https://pub.dev/packages/splashscreen
https://pub.dev/packages/package_info
https://pub.dev/packages/flutter_share_me
https://pub.flutter-io.cn/packages/simple_vcard_parser/
https://pub.dev/packages/permission_handler
https://pub.dev/packages/validators/versions
https://pub.dev/packages/intl
https://pub.dev/packages/qr_flutter
https://pub.dev/packages/vcard


**Créditos ao projeto original:**
https://github.com/aadarshchhetry/sqlTodoApp
