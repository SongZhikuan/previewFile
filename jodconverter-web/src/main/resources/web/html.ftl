<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
        }
        html, body {
            height: 100%;
            width: 100%;
        }
    </style>
</head>
<body>
    <iframe src="${pdfUrl}" width="100%" frameborder="0"></iframe>
</body>
<script src="js/watermark.js" type="text/javascript"></script>
<script type="text/javascript">
    var dHeight = document.documentElement.clientHeight-10;
    document.getElementsByTagName('iframe')[0].height = dHeight;

    var body = document.getElementsByTagName('iframe')[0].contentWindow.document.body;
    var timer = setInterval(function () {
        if (document.getElementsByTagName('iframe')[0].contentWindow.document.getElementsByTagName('table')[0]) {
            clearInterval(timer);
            var arr = location.search.split('setToolBarNumber|');
            var t = setTimeout(function () {
                clearTimeout(t);
                document.getElementsByTagName('iframe')[0].contentWindow.document.body.scrollTop = Number(arr[1] || 0);
            }, 100);
        }
    }, 100);
    /**
     * 监听滚动 并向上级页面发送事件
     */
    document.getElementsByTagName('iframe')[0].contentWindow.onscroll = function (e) {
        // console.log(body.offsetHeight - body.scrollTop);
        if (body.offsetHeight - dHeight - body.scrollTop <= 30) {
            window.parent.postMessage('ended|' + body.scrollTop + '|' + body.offsetHeight, '*');
        }
    }
    /**
     * iframe通信
     */
    window.addEventListener('message', function (e) {
        const data = e.data.split('|');
        console.log('html: ', data);
        if (data[0] === 'setToolBarNumber') {
            body.scrollTop = Number(data[2]);
        }
    })
    /**
     * 页面变化调整高度
     */
    window.onresize = function(){
        var fm = document.getElementsByTagName("iframe")[0];
        fm.height = window.document.documentElement.clientHeight-10;
    }
    /*初始化水印*/
    window.onload = function() {
        var watermarkTxt = '${watermarkTxt}';
        if (watermarkTxt !== '') {
            watermark.init({
                watermark_txt: '${watermarkTxt}',
                watermark_x: 0,
                watermark_y: 0,
                watermark_rows: 0,
                watermark_cols: 0,
                watermark_x_space: ${watermarkXSpace},
                watermark_y_space: ${watermarkYSpace},
                watermark_font: '${watermarkFont}',
                watermark_fontsize: '${watermarkFontsize}',
                watermark_color:'${watermarkColor}',
                watermark_alpha: ${watermarkAlpha},
                watermark_width: ${watermarkWidth},
                watermark_height: ${watermarkHeight},
                watermark_angle: ${watermarkAngle},
            });
        }
    }
</script>
</html>