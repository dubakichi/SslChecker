#!/bin/sh

if test $# -ne 1 ; then
    echo "[usage] sh ssl_checker.sh [調査対象URL]"
    exit 0;
fi
url=$1

today=`gdate +"%Y-%m-%d %H:%M:%S"`
# SSLサーバ証明書の有効期限を取得
# SSLサーバ証明書の期限に関する情報は標準エラー出力側に出力されるので、標準出力と標準エラー出力を差し替えている
# また標準エラー出力側にあるSSLサーバ証明書の有効期限を知りたいだけなので元々の標準出力の内容を捨てている
expire_date=`curl -v $url 2>&1 1> /dev/null | grep 'expire date:' | awk '{ print($4 " " $5 " " $6 " "  $7 " " $8)}' | xargs -I {} gdate +"%Y-%m-%d %H:%M:%S" -d {}`

echo "today:" $today;
echo "expire:" $expire_date;

expire_unix_time=`gdate +%s --date "$expire_date"`;
today_unix_time=`gdate +%s --date "$today"`;
diff=$(($expire_unix_time-$today_unix_time));

days_left=$(($diff / (60 * 60 * 24)));
echo "残日数：" $days_left;
