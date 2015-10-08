﻿-*-mode: text-*-
$Id: README,v 1.1 1998/06/30 12:43:58 kunishi Exp $

                *** dmail package Ver. 2.0  Rel. beta ***

                                  奈良先端科学技術大学院大学 情報科学研究科
                                                                 国島　丈生
                                                 kunishi@is.aist-nara.ac.jp
                                          kunishi@{kuis|imel}.kyoto-u.ac.jp

** はじめに

dmailは、メーリングリストで、NIFTYメンバを抱えている、などの
理由によって、メールをまとめて送付したい場合に用いると、有効(？)です。
送付のタイミングは cron を利用しているので自由に設定でき、
１つのファイルからなるメールとして、該当者に送付されます。

dmail Ver.2 は、Ver.1 をシェルスクリプトに書き換えると同時に、簡単な 
signal 処理、メールの queueing & flushing 処理、不要なヘッダの削除、ヘッ
ダ部分の MIME decoding 処理などを加えています。ただし、基本的なアルゴ
リズムは Ver.1 のままです。

** このパッケージの内容

以下の６つのファイルが含まれているはずです。確認して下さい。

 README         このファイル 
 README.v1      dmail Ver.1 のドキュメント
 header         メール配布時ヘッダ用ファイル
 members        メール配布対象者リスト
 saveMail.sh    メール到着時に保存するスクリプトファイル
 sendMail.sh    メール送信時に用いるスクリプトファイル

Ver.1 で必要だった members.sed は＊不要になりました＊。

** インストール

以下の手順に従って、順番にやっていって下さい。

１. パッケージの展開
　新たにディレクトリを作成し、その中にこのパッケージ一式を置いて下さい。
(以降の説明では、$DMAIL_ROOT=/usr/spool/dmail に置いたと仮定しています。)

　ディレクトリ $DMAIL_ROOT には saveMail.sh, sendMail.sh を起動する 
user の write permission が必要です。chmod を用いて permission を変更
しておいて下さい。
　たとえば、５で示すように /etc/aliases を設定した場合、saveMail.sh は 
daemon によって起動されますので、/usr/spool/dmail の owner によっては 
chmod a+w dmail などとしなければいけないかもしれません。

２. シェル変数を設定する
　saveMail.sh と sendMail.sh の先頭に

### Configuration Part ###
...
### End of Configuration Part ###

という部分があります。ここを、お使いの環境に併せて設定して下さい。各変
数の意味は以下の通りです。

・User Dependent Part
   - TOP_DIR (saveMail.sh, sendMail.sh)
     dmail パッケージを展開したディレクトリ。full path で書いて下さい。
   - LOCK_FILE (saveMail.sh, sendMail.sh)
     書き込みの排他制御を行うロックファイル名。通常変更する必要はあり
     ません。
   - SAVE_FILE (saveMail.sh, sendMail.sh)
     届いたメールをためておくファイル名。デフォルトは $DMAIL_ROOT/drafts
     となっています。通常変更する必要はありません。
   - TMP_DIR (sendMail.sh)
     sendMail.sh の作業用ディレクトリ。通常変更する必要はありません。
   - MEMBER_LIST (sendMail.sh)
     sendMail.sh を用いて配送する配送先リストのファイル。通常変更する
     必要はありません。
   - HEADER_FILE (sendMail.sh)
     sendMail.sh を用いて配送する時に、メールの先頭に付加される内容を
     書いておくファイル。通常変更する必要はありません。
   - LOG_FILE (sendMail.sh)
     sendMail.sh の配送ログを残すファイル名。# でこの行をコメントアウ
     トすると、ログファイルが作成されなくなります。
   - SPLIT_LINES (sendMail.sh)
     sendMail.sh によって配送されるメール1通の最大行数。NIFTYSERVE へ
     は 490 行以上のメールが送れないらしいので、デフォルトは 490 にし
     てあります。

・OS dependent Part
   - AWK (saveMail.sh)
     awk(1) の full path。
   - CAT (saveMail.sh, sendMail.sh)
     cat(1) の full path。
   - CHMOD (saveMail.sh)
     chmod(1) の full path。
   - CP (saveMail.sh)
     cp(1) の full path。
   - DATE (sendMail.sh)
     date(1) の full path。
   - ECHO (saveMail.sh, sendMail.sh)
     echo(1) の full path。
   - LS (sendMail.sh)
     ls(1) の full path。
   - MV (saveMail.sh)
     mv(1) の full path。
   - RM (saveMail.sh, sendMail.sh)
     rm(1) の full path。
   - SED (sendMail.sh)
     sed(1) の full path。
   - SLEEP (saveMail.sh, sendMail.sh)
     sleep(1) の full path。
   - TOUCH (saveMail.sh, sendMail.sh)
     touch(1) の full path。
   - WC (sendMail.sh)
     wc(1) の full path。
   - MIMEDECODER (sendMail.sh)
     MIME decoding プログラム。標準設定では nkf Ver.1.5 を仮定していま
     す。MIME decoding を行わない場合は $CAT を指定しておいて下さい。
   - DMAIL_OWNER (sendMail.sh)
     sendMail.sh によって発送するメールの envelope from。最近の 
     sendmail は、エラーメールの返送の際、Errors-To: フィールドではな
     く envelope from を見ます。あるいは、企業などで発信規制がかかって
     いる場合にも envelope from でチェックしているケースが多いようです。
     「ML を運営する際には、/usr/lib/sendmail を起動する際に -f オプショ
     ンをつけて……」云々の注意事項があれば、この envelope from のこと
     を指していると思ってよいでしょう。
     なお、この変数は $MAIL_COMMAND が sendmail である時のみ有効であり、
     それ以外の場合は envelope from は sendMail.sh を起動した owner 自
     身のアドレスになります。
     以上の説明を読んでわからない場合は、とりあえずあなたのメールアド
     レスを書いておいて下さい(^_^;;)。
   - MAIL_COMMAND (sendMail.sh)
     メールを配送するコマンド(mail transfer agent)。sendMail.sh を 
     root で起動するなら、/usr/lib/sendmail のままでよいでしょう。
     何らかの事情で root で sendmail.sh を実行したくない場合には、
     sendmail.cf 中の Mlocal で始まる行を探し、そこに指定されているコ
     マンドを書いて下さい。変態的な OS :-)でない限り
         BSD 系なら  /bin/mail
         SysV 系なら /bin/rmail
     でよいと思います。
   - QUEUE_FLUSH_COMMAND (sendMail.sh)
     MAIL_COMMAND が sendmail の時のみ有効です。sendMail.sh
     で採用しているアルゴリズムでは、分割したパートの数だけ同時に 
     sendmail が走るため、悪くすると dmail を設定している計算機にひじょ
     うに大きな負荷がかかります。これを防ぐために、一旦すべてのメール
     を mail queue に蓄えた後、flushing をしてメールを配送するほうが良
     いと思われます。この、flushing のためのコマンドの定義です。
     MAIL_COMMAND と QUEUE_FLUSH_COMMAND は、sendMail.sh 中のコメント
     をよくお読みになった上、設定して下さい。

３. メンバを登録する
　sendMail.sh によりメールを発送するメンバを $MEMBER_FILE に登録します。
行頭が # で始まる行は、コメントとして処理されます。最後に貴方(管理者)
も書いておくと、完璧かも。

４. ヘッダファイルを作成する
　header ($HEADER_FILE)の中身を書き換えて下さい。最初の空行までがその
ままメールのヘッダに付加され、後は本文としてメールの body の先頭に付加
されます。
　ヘッダのうち、特に From: と Errors-To: は、$DMAIL_OWNER と同じか、あ
るいはあなた自身のアドレスにしておいて下さい。Reply-To:, Subject: は好
みに応じて書き換えて下さい(削っても構いません)。

５. aliases を修正する

   foo: a@where.jp, b@where.jp, bar
   bar: "| /usr/spool/dmail/saveMail.sh"

なる２行にしてください。

　あるいは、

   hamoru:   :include:/usr/spool/dmail/hamoru.list

というふうに書いておき、hamoru.list の中に

   foo@**.co.jp
   bar@**.co.jp
   "|/bin/sh /usr/spool/dmail/saveMail.sh 2>>/usr/spool/dmail/log"

と書く、てな事もできます。ただし、この記法は、sendmail の種類によって
はできませんので、OS や sendmail をよく確認の上、設定して下さい。

６. newaliases コマンドを実行する
　この瞬間から保存され始めるはずです。

７. cron により sendMail.sh を起動する設定を行う。
　マシン・OSによって、全然異なります。詳しくは cron(8) または
crontab(5) を参照して下さい。
　大まかにいって、
  ・BSD 系では、crontab をエディタで書き換える。
  ・SysV 系、SunOS 4.1.* では、スクリプトを実行させたい user になって
    から crontabs -e を実行し、cron を設定する。
という手順を踏めばよいでしょう。いずれの場合も、cron の立ちあげ直しは
不要です。
　なお、cron を root の権限で動かすかどうかによって、sendMail.sh 中の 
MAIL_COMMAND, DMAIL_OWNER などの設定が変わります。

** えーっ、うそー、うごかへん

 + header ファイルは、あなたのサイトでメールの本文を編集する際の標準的
   な漢字コードにしておきましょう。Internet に出ていく時の漢字コードは 
   JIS でなければなりませんので、sendmail.cf などに特に細工をしていな
   い場合は JIS コードでしょうが、サイトによって異なります。

 + SysV 系、SunOS4.1.* では、/usr/spool/cron/crontabs/ の下のファイルを
   単に編集したのでは cron の動作は変化しません。crontab -e を使うか、
   編集した後 cron を立ちあげ直して下さい。

 + メールの envelope from は正しく設定されていますか？
   企業などで外部とのメールの発信チェックを行っている場合、スクリプト
   を root さんに実行させると発信チェックに引っかかって「rootは外にメール
   を出せない」と、突き返されることがあります。

 + $DMAIL_ROOT のパーミッションは正しく設定されていますか。saveMail.sh 
   や sendMail.sh を起動する owner に writable になるように設定して下
   さい。

** 動作環境

dmail Ver.1 は Sparc IPC & SunOS 4.1.1 上でテストを行っており、ME(三菱
社製 UNIX マシン、system V)で、半年ほど動いております。

dmail Ver.2 は、今のところ SparcStation 10 (SunOS 4.1.3_U1) 上で動作す
ることを確認しています。1996/01/8 現在、7カ月程の動作実績があります。

なお、NEWS-OS 4.2.1a では B-shell の signal 処理のうち signal 11 だけ
が扱えないそうです(From 齊藤穰 (yutaka@vsp.cpg.sony.co.jp))。このこと
から類推するに、OS によっては sendMail.sh, saveMail.sh の trap 処理の 
signal 番号リストの部分を書き換えてやらなければいけないと思われます。
signal 処理はあんまりちゃんと分かっていないので、「こんな signal 処理
はいらん」とかいう御指摘は大歓迎です。

** Bug Report

Bug Report 、インストール時のトラブルは国島まで。間違っても Ver.1 の作
者には送らないよーに。(彼女は B-shell が分からないそうなので(^_^;;))

** 配布条件

dmail Ver.1 は GNU License に準拠するということでしたが、dmail Ver.2 
は Public Domain に置くものとします。煮るなり焼くなり、好きにしていた
だいて結構です。

Ver.1 の作者に問い合わせたところ、「恥ずかしいので再配布してほしくない
けど、書き換えていただければ再配布して構わない」ということでしたので、
需要もあるようですし、Public Domain に置いてしまいます。
