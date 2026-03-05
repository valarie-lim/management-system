<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="attendance-record.aspx.vb" Inherits="sunday_school_ms.attendance_record" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Record Attendance</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link runat="server" rel="stylesheet" href="../CSS/style.css"/>
    <link rel="stylesheet" href="https://unpkg.com/boxicons@latest/css/boxicons.min.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet" />
    <style>
        table {border-collapse: collapse;width: 100%;}th, td {border: 1px solid #ccc;padding: 8px;}
        #menu-icon {color: white;font-size: 30px;z-index: 100;cursor: pointer;display:none;}
        /* Drawer base */
        #drawer {position: fixed;top: 0;right: -260px;width: 260px;height: 100%;background: #fff8d9;box-shadow: -3px 0 10px rgba(0,0,0,0.15);padding: 20px;z-index: 999;transition: right 0.3s ease-in-out;display: flex;flex-direction: column;gap: 15px;}
        #drawer.open {right: 0;}
        .drawer-header {display: flex;justify-content: space-between;align-items:flex-end;}
        #drawer-close {font-size: 28px;cursor: pointer;}

@media (max-width:360px){
            .header-right{display:none;}
            #menu-icon {display:block;cursor: pointer;}
            .navlist{font-size:16px;color:black;}
            .navlist li, .drawer-nav, .drawer-nav li {list-style: none;padding-left: 0; margin-left: 0;}
            .menu-container, .right-menu-container{padding:1%;margin-right:1% auto;}
            .filter-wrapper{margin:5% auto;gap:5px;width:80%;}
            .filter-txtbox{width:100%}
            .btn-filter,.btn-normal{width:100%;margin:3% auto;}
            th, td {padding: 3px;margin:0 auto;}}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header id="main-header">
            <div class="header-left">
                <a href="#" class="logo-style">
                    <img src="../Images/logo.png" /></a>
                <h3>儿童出勤登记</h3>
            </div>
            <div class="header-right" id="desktop-menu">
                <ul class="navlist">
                    <li>Hi,&nbsp;<asp:Label ID="UserRole" runat="server"></asp:Label></li>
                    <li><span id="LiveClock" class="timestamp-font-size"></span></li>
                </ul>
                <asp:Button ID="BtnMenu" runat="server"
                    CssClass="btn-logout"
                    Style="border-radius: 5px;"
                    Text="回去主界面" />
                <asp:Button ID="BtnExit" runat="server"
                    CssClass="btn-logout"
                    Style="border-radius: 5px;" Text="退出"
                    OnClientClick="return confirm('确定要退出吗？');" />
            </div>
            <div class="bx bx-menu" id="menu-icon"></div>
            <!-- MOBILE DRAWER -->
            <div id="drawer">
                <div class="drawer-header">
                    <i class='bx bx-x' id="drawer-close"></i>
                </div>
                <ul class="navlist drawer-nav">
                    <li>Hi,&nbsp;<asp:Label ID="UserRoleMobile" runat="server"></asp:Label></li>
                    <li><span id="LiveClockMobile" class="timestamp-font-size"></span></li>
                </ul>

                <asp:Button ID="BtnMenuMobile" runat="server" CssClass="btn-logout" Text="回去主界面" />
                <asp:Button ID="BtnExitMobile" runat="server" CssClass="btn-logout"
                    Text="退出" OnClientClick="return confirm('确定要退出吗？');" />
            </div>
        </header>
        <br />
        <!-- main content -->
        <div class="menu-container">
            <div class="right-menu-container">
                <h4 >操作说明：<span style="color: red;">先选择日期和活动，再勾选所有出席的小朋友后点击“提交记录”。如需修改，可到“更改/查看出勤汇总”。</span></h4>
<hr />
                <div class="filter-wrapper">
                    <asp:Label ID="lblDate" runat="server" Text="日期: "></asp:Label>
                    <asp:TextBox ID="txtActivityDate" runat="server" TextMode="Date" CssClass="filter-txtbox"></asp:TextBox>
                    <asp:Label ID="lblActivity" runat="server" Text="活动: "></asp:Label>
                    <asp:DropDownList
                        ID="ddlActivity"
                        runat="server"
                        CssClass="filter-txtbox"
                        DataTextField="activity_name"
                        DataValueField="activity_id"
                        DataSourceID="SqlDataSource_Activity"
                        AppendDataBoundItems="True">
                        <asp:ListItem Text="- Select Activity -" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="BtnUpdate" runat="server" Text="提交记录" CssClass="btn-normal" />
                    <asp:Button ID="BtnView" runat="server" Text="更改/查看出勤汇总" CssClass="btn-filter" />
                </div>
                <br />
                <asp:GridView
                    ID="GridView_recordAttendance" runat="server"
                    AllowPaging="True" PageSize="60" AllowSorting="True" AutoGenerateColumns="False"
                    DataKeyNames="child_id" DataSourceID="SqlDataSource_recordAttendance"
                    Width="60%">

                    <Columns>
                        <asp:BoundField DataField="EnglishName" HeaderText="名字（英）" ItemStyle-Width="250px" ReadOnly="True" />
                        <asp:BoundField DataField="chinese_name" HeaderText="名字（中）" ItemStyle-Width="100px" ReadOnly="True" />
                        <asp:TemplateField HeaderText="性别" HeaderStyle-Width="50" >
                            <ItemTemplate>
                                <%# If(Eval("gender").ToString()="1","男","女") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="age" HeaderText="年龄" ItemStyle-Width="50px" ReadOnly="True" />
                        <asp:BoundField DataField="class_name" HeaderText="班级" SortExpression="class_name" ItemStyle-Width="100px" ReadOnly="True" />
                        <asp:TemplateField HeaderText="出席" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkAttendance" runat="server"
                                    Checked='<%# Convert.ToBoolean(Eval("IsPresent")) %>'
                                    CssClass="chkAttendance-style" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>

                    <HeaderStyle BackColor="Black" ForeColor="White" Font-Bold="True" />
                </asp:GridView>
                <asp:SqlDataSource
                    ID="SqlDataSource_Activity"
                    runat="server"
                    ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                    SelectCommand="SELECT *
                        FROM activity
                        ORDER BY activity_name"></asp:SqlDataSource>
                <asp:SqlDataSource
                    ID="SqlDataSource_recordAttendance"
                    runat="server"
                    ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                    SelectCommand="
                        SELECT 
                            c.child_id,
                            (c.first_name + ' ' + c.last_name) AS EnglishName,
                            c.chinese_name,
                            c.gender,
                            c.age,
                            cl.class_name,
                            cl.classroom,
                            CAST(0 AS bit) AS isPresent
                        FROM child c
                        INNER JOIN class cl ON c.class_id = cl.class_id
                        "></asp:SqlDataSource>
            </div>
        </div>
    </form>
    
    <script>
        const menuIcon = document.getElementById("menu-icon");
        const drawer = document.getElementById("drawer");
        const drawerClose = document.getElementById("drawer-close");

        menuIcon.addEventListener("click", () => {
            drawer.classList.add("open");
        });

        drawerClose.addEventListener("click", () => {
            drawer.classList.remove("open");
        });
    </script>
</body>
</html>