<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>PDF预览</title>
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
    <#if pdfUrl?contains("http://") || pdfUrl?contains("https://")>
        <#assign finalUrl="${pdfUrl}">
    <#else>
        <#assign finalUrl="${baseUrl}${pdfUrl}">
    </#if>
    <iframe src="" width="100%" frameborder="0"></iframe>

    <img src="images/jpg.svg" width="63" height="63" style="position: fixed; cursor: pointer; top: 40%; right: 48px; z-index: 999;" alt="使用图片预览" title="使用图片预览" onclick="goForImage()"/>

</body>
<script src="js/watermark.js" type="text/javascript"></script>
<script type="text/javascript">
    document.getElementsByTagName('iframe')[0].src = "${baseUrl}pdfjs/web/viewer.html?base=${baseUrl}&file="+encodeURIComponent('${finalUrl}')+"&disabledownload=${pdfDownloadDisable}";
    console.log(document.getElementsByTagName('iframe')[0].src);
    document.getElementsByTagName('iframe')[0].height = document.documentElement.clientHeight-10;
    hiddenImageHandleButton();

    /**
     * 监听toolbar page change
     */
    document.getElementsByTagName('iframe')[0].onload = function() {
        // console.log("frames onload")
        var pdfViewerApp = frames[0].PDFViewerApplication;
        var t = setTimeout(function () {
            window.parent.postMessage('pagenumberchanged|' + pdfViewerApp.page + '|' + pdfViewerApp.pagesCount, '*');
            clearTimeout(t);
        }, 2000);
        pdfViewerApp.eventBus._on("pagechanging", function (evt) {
            console.log('pagenumberchanged: ', evt);
            window.parent.postMessage('pagenumberchanged|' + evt.pageNumber + '|' + pdfViewerApp.pagesCount, '*');
        });
        pdfViewerApp.eventBus._on("firstpage", function (evt) {
            console.log('firstpage: ', evt);
            // window.parent.postMessage('pagenumberchanged|' + evt.pageNumber + '|' + pdfViewerApp.pagesCount, '*');
        });
    };
    /**
     * iframe通信
     */
    window.addEventListener('message', function (e) {
        const data = e.data.split('|');
        if (data[0] === 'setToolBarNumber') {
            setToolbarPageNumber(Number(data[1]) || 1);
        }
        // console.log(e.data)  //e.data为传递过来的数据
        // console.log(e.origin)  //e.origin为调用 postMessage 时消息发送方窗口的 origin（域名、协议和端口）
        // console.log(e.source)  //e.source为对发送消息的窗口对象的引用，可以使用此来在具有不同origin的两个窗口之间建立双向通信
    })

    /**
     * 设置toolbar的页码
     */
    function setToolbarPageNumber(page) {
        // console.log(frames[0]);
        frames[0].PDFViewerApplication.page = page;
    }
    /**
     * 隐藏操作按钮
     */
    function hiddenImageHandleButton() {
        document.getElementsByTagName('img')[0].style.display = 'none';
    }
    /**
     * 页面变化调整高度
     */
    window.onresize = function(){
        var fm = document.getElementsByTagName("iframe")[0];
        fm.height = window.document.documentElement.clientHeight-10;
    }

    function goForImage() {
        var url = window.location.href;
        if (url.indexOf("officePreviewType=pdf") != -1) {
            url = url.replace("officePreviewType=pdf", "officePreviewType=image");
        } else {
            url = url + "&officePreviewType=image";
        }
        window.location.href=url;
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