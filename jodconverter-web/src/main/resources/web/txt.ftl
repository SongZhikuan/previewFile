<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>普通文本预览</title>
    <style>
        * {
            margin: 0;
            padding: 0;
        }
        html {
            height: 100%;
            width: 100%;
        }
    </style>
</head>
<body>
<div id = "text"></div>
<script src="js/jquery-3.0.0.min.js" type="text/javascript"></script>
<script src="js/watermark.js" type="text/javascript"></script>
<script>
    var dHeight = document.documentElement.clientHeight;

    /**
     * 监听滚动 并向上级页面发送事件
     */
    window.onscroll = function (e) {
        var body = document.body;
        if (body.offsetHeight - dHeight - document.documentElement.scrollTop <= 30) {
            window.parent.postMessage('ended|' + document.documentElement.scrollTop + '|' + body.offsetHeight, '*');
        }
    }
    /**
     * iframe通信
     */
    window.addEventListener('message', function (e) {
        const data = e.data.split('|');
        console.log('text: ', data);
        if (data[0] === 'setToolBarNumber') {
            body.scrollTop = Number(data[2]);
        }
    })
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
        $.ajax({
            type: 'GET',
            url: '${ordinaryUrl}',
            success: function (data) {
                $("#text").html("<pre>" + data + "</pre>");
                var arr = location.search.split('setToolBarNumber|');
                if (arr[1]) {
                    var t = setTimeout(function () {
                        clearTimeout(t);
                        document.documentElement.scrollTop = Number(arr[1] || 0);
                    }, 100);
                }
            }
        });
    }

</script>
</body>

</html>
