<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Expo - Netdata</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <script src="js/jquery-1.9.1.min.js"></script>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/bootstrap.min.js"></script>
    <link href="css/font-awesome-4.5.0/css/font-awesome.css" rel="stylesheet" />
    <script src="/js/moment-master/min/moment-with-locales.min.js"></script>
    <link href="/bootstrap-datetimepicker-master/build/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
    <script src="/bootstrap-datetimepicker-master/build/js/bootstrap-datetimepicker.min.js"></script>
    <link rel="shortcut icon" href="/../img/favicon32.ico" />
    <link href="css/sweetalert.css" rel="stylesheet" />
    <link href="css/checbox/build.css" rel="stylesheet" />

    <link href="css/style.css" rel="stylesheet" />

    <style>
        .modal-open .modal {
            padding-left: 0px !important;
            padding-right: 0px !important;
            overflow-y: scroll;
        }

        #mapjs {
            height: calc(100vh - 163px);
            position: relative;
            right: 10px;
            top: 32px;
            margin-bottom: 0px;
            overflow: auto;
        }

        #map {
            position: relative;
            height: calc(100vh - 195px);
            right: 10px;
            top: 12px;
            bottom: 0;
            margin-left: 10px;
            overflow: hidden;
        }

        .navbar-inverse .navbar-nav > li > a {
            color: #fff;
        }

            .navbar-inverse .navbar-nav > li > a:hover, .navbar-inverse .navbar-nav > li > a:focus {
                background-color: #3A75D7;
            }

        .navbar-inverse .navbar-nav > .open > a, .navbar-inverse .navbar-nav > .open > a:focus, .navbar-inverse .navbar-nav > .open > a:hover {
            background-color: #3A75D7;
        }

        .navbar {
            border-radius: 0px;
        }

        .btn-link {
            padding: 16px;
        }

        .li > a {
            cursor: pointer;
        }


        a.list-group-item .list-group-item-heading, .list-group-item-text {
            color: white;
        }

        .list-group-item {
            background-color: #4285F4;
            border: 1px solid #3A75D7;
        }

        a.list-group-item:hover, a.list-group-item:focus {
            text-decoration: none;
            color: #fff;
            background-color: #3A75D7;
        }

        .list-group-item.active, list-group-item.active:focus, .list-group-item.active:hover {
            z-index: 2;
            color: #ffffff;
            background-color: #3A75D7;
            border-color: #3A75D7;
        }
    </style>
</head>
<body runat="server" style="background-image: url('image/green.jpg');">

    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="true">
            <Scripts>
                <%--<asp:ScriptReference ScriptMode="Release" Path="~/ExpoArea/NetMap/js/NetMapResource.js" />--%>
                <asp:ScriptReference ScriptMode="Release" Path="~/js/NetGPS.js" />
            </Scripts>
        </asp:ScriptManager>



        <nav style="background: #4285F4; border-color: #1995dc;" class="navbar  navbar-inverse">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a style="padding-top: 10px;" class="navbar-brand" href="http://www.netdata.com/">
                        <img src="image/logofornetsite2.png" alt="Netdata" />
                    </a>
                </div>
                <div class="collapse navbar-collapse" id="myNavbar">
                    <ul class="nav navbar-nav">
                        <li class=""><a target="_blank" href="https://github.com/netdata-examples/GpsTracking/wiki"><span class="spnShowDocument"></span></a></li>
                        <li class=""><a target="_blank" href="https://github.com/netdata-examples/GpsTracking"><span class="spnDownloadCodes"></span></a></li>
                        <li class=""><a target="_blank" href="http://www.netdata.com/IFRAME/28FD6C31"><span class="spnShowDatas"></span></a></li>

                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#"><span class="glyphicon glyphicon-globe"></span>
                                <span class="spnChooseLanguage"></span>
                                <span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a style="cursor: pointer;" onclick="ChangeLang('tr-TR');"><span class="spnTurkish"></span></a></li>
                                <li><a style="cursor: pointer;" onclick="ChangeLang('en-US');"><span class="spnEnglish"></span></a></li>
                            </ul>
                        </li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li style="height: 32px;">
                            <div style="margin-top: 8px;" class="netdata-social-share text-center"></div>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <%--<div class="text-left " style="margin-top: -10px; margin-left: 10px;">
            <span class="spnDataDeleted" style="color: #fff"></span>
        </div>--%>

        <div class="container-fluid" id="main">

            <div id="namePanel" class="row-fluid" style="margin-top: 50px;">
                <div class="col-md-6 col-md-offset-3 login-box text-center">
                    <span style="padding: 15px; font-size: 18px; white-space: pre-wrap" class="label col-centered"><span class="spnEnterXML">Kullanmak için Oluşturduğunuz Uygulamanın Xml Erişim Adresini Giriniz</span></span>
                    <br>

                    <div class="input-group">
                        <span class="input-group-addon" id="sizing-addon1">http://www.netdata.com/XML/</span>
                        <input style="" class="form-control col-centered" type="text" id="txtUrl" name="MessageText" value="315BF07D" maxlength="8">
                    </div>


                    <button onclick="GetMarkers()" class="btn btn-success col-centered login-button" type="button" id="nameSetButton"><span class="spnEnter">Giriş</span></button>
                    <label class="alert alert-danger" id="lblUyari" style="margin-top: 20px; display: none;"></label>
                </div>
            </div>


            <div id="mapPanel" style="display: none;" class="row">

                <div class="col-xs-12 text-center">
                    <h4 style="margin-top: 0px;" class="c-white"><span class="spnSelectDateRange"></span></h4>
                </div>

                <div class="padding-left: 10px;" style="margin-top: -5px;">
                    <div class="col-md-4 col-sm-12">
                        <label class="c-white" for="startDate"><span class="spnStartDate"></span></label>
                        <div class='input-group input-group-sm date timepicker' id='datetimepicker1' style="margin-right: 10px;">
                            <input id="startDate" name="startDate" value="" type='text' class="form-control hour" />
                            <span class="input-group-addon">
                                <span class="glyphicon glyphicon-time"></span>
                            </span>
                        </div>
                    </div>

                    <div class="col-md-4 col-sm-12">
                        <label class="c-white" for="endDate"><span class="spnEndDate"></span></label>
                        <div class='input-group input-group-sm date timepicker' id='datetimepicker2' style="margin-right: 10px;">
                            <input id="endDate" value="" name="endDate" type='text' class="form-control hour" />
                            <span class="input-group-addon">
                                <span class="glyphicon glyphicon-time"></span>
                            </span>
                        </div>
                    </div>

                    <div class="col-md-4 col-sm-12">
                        <button onclick="GetMarkers()" style="margin-top: 22px; margin-right: 10px; min-width: 100px" type="button" class="btn btn-success pull-right"><span class="spnFilter"></span></button>

                        <div class="checkbox pull-left" id="ShowPoints" style="margin-top: 30px;">
                            <input data-val="true" data-val-required="RememberMe alanı gereklidir." id="chkShowPoints" name="chkShowPoints" type="checkbox" value="false">
                            <label for="chkShowPoints" class="c-white">
                                <span class="spnShowAllPoints"></span>
                            </label>
                        </div>
                    </div>
                </div>
                <%--<div class="col-md-4 col-xs-4">

                    <div class="" style="position: relative; right: 10px; top: 12px;">
                        <div class="input-group">
                            <input type="text" class="form-control" name="name" id="aranankelime" />
                            <span class="input-group-btn">
                                <a id="arama" class="btn btn-warning" style="background-color: #FF5722; border-color: #FF5722; background-image: none" onclick="Ara()"><span class="spnSearch"></span></a>
                            </span>
                        </div>
                    </div>

                    <div class="list-group" id="mapjs">
                    </div>
                </div>--%>

                <div class="col-md-4 hidden-sm hidden-xs">
                    <div class="list-group" id="mapjs" style="padding-left: 10px; margin-top: -20px; height: calc(100vh - 195px);">
                    </div>
                </div>
                <div class="col-md-8 col-xs-12">
                    <div id="map"></div>
                </div>
            </div>
        </div>

        <script>

            function GetLang() {
                $('.spnShowMap').html(ntdtdilHaritayıGoster);
                $('.spnShowDocument').html(ntdtdilKullanimDokumani);
                $('.spnDownloadCodes').html(ntdtdilKodlariIndir);
                $('.spnShowDatas').html(ntdtdilVerileriGoster);
                $('.spnSearch').html(ntdtdilAra);
                $('.spnSave').html(ntdtdilKaydet);
                $('.spnHomePage').html(ntdtdilHomePage);
                $('.spnAddPoint').html(ntdtdilYeniVeriEkle);
                $('#txtareaname').attr("placeholder", ntdtdilIsimVer);
                $('#aranankelime').attr("placeholder", ntdtdilYerleskeAra);
                $('.spnChooseLanguage').html(ntdtDilSec);
                $('.spnTurkish').html(ntdtTurkce);
                $('.spnEnglish').html(ntdtInglizce);
                $(".spnDataDeleted").text(ntdtdilVerilerSilinecek);

                $('.spnShowAllPoints').html(ntdtdilTumNoktalariGoster);
                $('.spnEnterXML').html(ntdtdilXMLGir);
                $('.spnEnter').html(ntdtdilGiris);
                $(".spnSelectDateRange").text(ntdtdilTarihSec);

                $('.spnStartDate').html(ntdtdilBaslangicTarihi);
                $('.spnEndDate').html(ntdtdilBitisTarihi);
                $(".spnFilter").text(ntdtdilFiltrele);

            }
            GetLang();

            $(function () {
                $('.timepicker').datetimepicker({
                    format: 'DD.MM.YYYY',
                    locale: ntdtdilDatePickerLanguage,
                    //defaultDate: '00:00'
                });
            });

            $("#chkShowPoints").change(function () {
                if (this.checked) {
                    showMarkers("all");
                }
                else {
                    showMarkers("startend");
                }
            });

        </script>

        <script src="js/sweetalert.min.js"></script>
        <script src="js/NetGPS.js"></script>
        <script src="js/Sharer.js"></script>
        <script>
            (function (i, s, o, g, r, a, m) {
                i['GoogleAnalyticsObject'] = r; i[r] = i[r] || function () {
                    (i[r].q = i[r].q || []).push(arguments)
                }, i[r].l = 1 * new Date(); a = s.createElement(o),
                m = s.getElementsByTagName(o)[0]; a.async = 1; a.src = g; m.parentNode.insertBefore(a, m)
            })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

            ga('create', 'UA-66551872-1', 'auto');
            ga('send', 'pageview');
        </script>
        <script type="text/javascript">
            _atrk_opts = { atrk_acct: "lBPFm1akKd604B", domain: "netdata.com", dynamic: true };
            (function () { var as = document.createElement('script'); as.type = 'text/javascript'; as.async = true; as.src = "https://d31qbv1cthcecs.cloudfront.net/atrk.js"; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(as, s); })();
        </script>
        <noscript><img src="https://d5nxst8fruw4z.cloudfront.net/atrk.gif?account=lBPFm1akKd604B" alt="." style="display:none" height="1" width="1" alt="" /></noscript>

    </form>
</body>
</html>
