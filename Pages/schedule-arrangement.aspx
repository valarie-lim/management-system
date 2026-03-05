<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="schedule-arrangement.aspx.vb" Inherits="sunday_school_ms.schedule_arrangement" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Teacher and Activity Schedule Arrangement</title>
    <link runat="server" rel="stylesheet" href="../CSS/style.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet" />
    <style>
        .WideGridview {white-space: nowrap;}
        table.WideGridview td, table.WideGridview th {padding: 8px !important;}
        .WideGridview th {position: sticky;top: 0;background: black;z-index: 2;}
        .halfyear-radio input[type="radio"] {margin-right: 10px;}
        .halfyear-radio label {margin-right: 20px;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header id="main-header">
            <div class="header-left">
                <a href="#" class="logo-style">
                    <img src="../Images/logo.png"/></a>
                <h3>事奉表安排</h3>
            </div>
            <div class="header-right">
                <ul class="navlist">
                    <li><span id="LiveClock" class="timestamp-font-size"></span></li>
                </ul>
                <asp:Button ID="BtnReport" runat="server"
                    CssClass="btn-filter"
                    ClientIDMode="Static"
                    Text="查看和打印事奉表" />
                <asp:Button ID="BtnReturn" runat="server"
                    CssClass="btn-normal"
                    Style="border-radius: 5px;" Text="回去主界面" />
            </div>
        </header>
        <!-- main content -->
        <div class="menu-container">
            <div class="right-menu-container">
                <!-- ALL DataSource -->
                <div>
                    <asp:SqlDataSource
                        ID="SqlDataSource_Class"
                        runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="SELECT * FROM dbo.class"></asp:SqlDataSource>

                    <asp:SqlDataSource
                        ID="SqlDataSource_TA"
                        runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT s.staff_id, (p.chinese_name) AS Name, s.role 
                            FROM staff s
                            INNER JOIN person p ON s.person_id = p.person_id
                            WHERE s.role = 'Teaching Assistants';"></asp:SqlDataSource>

                    <asp:SqlDataSource
                        ID="SqlDataSource_Speaker"
                        runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT s.staff_id, p.chinese_name AS Name
                            FROM staff s
                            INNER JOIN person p ON s.person_id = p.person_id
                            INNER JOIN service se ON s.staff_id = se.staff_id
                            INNER JOIN serviceList sl ON se.serviceList_id = sl.serviceList_id
                            WHERE sl.service_type = '讲员';"></asp:SqlDataSource>

                    <asp:SqlDataSource
                        ID="SqlDataSource_SongLeader1"
                        runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT s.staff_id, p.chinese_name AS Name
                            FROM staff s
                            INNER JOIN person p ON s.person_id = p.person_id
                            INNER JOIN service se ON s.staff_id = se.staff_id
                            INNER JOIN serviceList sl ON se.serviceList_id = sl.serviceList_id
                            WHERE sl.service_type = '领唱1';"></asp:SqlDataSource>

                    <asp:SqlDataSource
                        ID="SqlDataSource_SongLeader2"
                        runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT s.staff_id, p.chinese_name AS Name
                            FROM staff s
                            INNER JOIN person p ON s.person_id = p.person_id
                            INNER JOIN service se ON s.staff_id = se.staff_id
                            INNER JOIN serviceList sl ON se.serviceList_id = sl.serviceList_id
                            WHERE sl.service_type = '领唱2';"></asp:SqlDataSource>

                    <asp:SqlDataSource
                        ID="SqlDataSource_Pianist"
                        runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT s.staff_id, p.chinese_name AS Name
                            FROM staff s
                            INNER JOIN person p ON s.person_id = p.person_id
                            INNER JOIN service se ON s.staff_id = se.staff_id
                            INNER JOIN serviceList sl ON se.serviceList_id = sl.serviceList_id
                            WHERE sl.service_type = '司琴';"></asp:SqlDataSource>

                    <asp:SqlDataSource
                        ID="SqlDataSource_Prayer"
                        runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT s.staff_id, p.chinese_name AS Name
                            FROM staff s
                            INNER JOIN person p ON s.person_id = p.person_id
                            INNER JOIN service se ON s.staff_id = se.staff_id
                            INNER JOIN serviceList sl ON se.serviceList_id = sl.serviceList_id
                            WHERE sl.service_type = '代祷';"></asp:SqlDataSource>

                    <asp:SqlDataSource
                        ID="SqlDataSource_Theory"
                        runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT s.staff_id, p.chinese_name AS Name
                            FROM staff s
                            INNER JOIN person p ON s.person_id = p.person_id
                            INNER JOIN service se ON s.staff_id = se.staff_id
                            INNER JOIN serviceList sl ON se.serviceList_id = sl.serviceList_id
                            WHERE sl.service_type = '小要理';"></asp:SqlDataSource>
                </div>

                <!-- Gridview filter to view and modify arrangement details -->
                <div class="filter-menu">
                    <div class="filter-wrapper">
                        <asp:TextBox ID="TxtActivityYear" runat="server" Placeholder="年份搜索。例子: 2025"
                            AutoPostBack="True" CssClass="filter-txtbox"
                            OnTextChanged="TxtActivityYear_TextChanged">
                        </asp:TextBox>
                        <asp:Button ID="BtnSearch" runat="server" Text="搜索" CssClass="btn-filter" />
                        <h4 style="color: red;">搜索年份 或 输入数字 0 显示全部活动（除了儿童诗班）。</h4>
                    </div>
                    <div class="filter-wrapper">
                        <asp:RadioButtonList ID="rblHalfYear" runat="server" AutoPostBack="True"
                            OnSelectedIndexChanged="FilterGrid" RepeatDirection="Horizontal" CssClass="halfyear-radio">
                            <asp:ListItem Text="全部" Value="0" Selected="True" />
                            <asp:ListItem Text="1月-6月" Value="1" />
                            <asp:ListItem Text="7月-12月" Value="2" />
                        </asp:RadioButtonList>
                    </div>
                </div>
                <br />
                <!-- Gridview -->
                <div style="overflow-x: auto; width: 100%;">
                    <asp:GridView ID="GridView_Arrangement" runat="server"
                        AllowPaging="True" PageSize="60" AllowSorting="True" AutoGenerateColumns="False"
                        BackColor="White" BorderColor="#999999" BorderStyle="Solid"
                        BorderWidth="1px" CellPadding="3"
                        ForeColor="Black" GridLines="Vertical" CssClass="WideGridview"
                        DataKeyNames="record_id,schedule_id" DataSourceID="SqlDataSource_Arrangement">

                        <AlternatingRowStyle BackColor="#CCCCCC" />

                        <Columns>
                            <asp:CommandField ShowEditButton="True" HeaderText="编辑" />

                            <asp:TemplateField HeaderText="日期" SortExpression="Date">
                                <ItemTemplate>
                                    <%# Eval("Date", "{0:yyyy-MM-dd}") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="节目" SortExpression="Activity">
                                <ItemTemplate>
                                    <%# Eval("Activity") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="领唱">
                                <ItemTemplate>
                                    <%# Eval("CL00-SongLeader1") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditSongLeader1_ALL" runat="server"
                                        DataSourceID="SqlDataSource_SongLeader1"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="助唱">
                                <ItemTemplate>
                                    <%# Eval("CL00-SongLeader2") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditSongLeader2_ALL" runat="server"
                                        DataSourceID="SqlDataSource_SongLeader2"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="司琴">
                                <ItemTemplate>
                                    <%# Eval("CL00-Pianist") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditPianist_ALL" runat="server"
                                        DataSourceID="SqlDataSource_Pianist"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="小要理">
                                <ItemTemplate>
                                    <%# Eval("CL00-Theory") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditTheory_ALL" runat="server"
                                        DataSourceID="SqlDataSource_Theory"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="国家代祷">
                                <ItemTemplate>
                                    <%# Eval("CL00-Prayer") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditPrayer_ALL" runat="server"
                                        DataSourceID="SqlDataSource_Prayer"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>



                            <asp:TemplateField HeaderText="幼儿班讲员">
                                <ItemTemplate>
                                    <%# Eval("[CL01-Speaker]") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditSpeaker_CL01" runat="server"
                                        DataSourceID="SqlDataSource_Speaker"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="幼儿班：协助">
                                <ItemTemplate>
                                    <%# Eval("[CL01-Assistant]") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditTA_CL01" runat="server"
                                        DataSourceID="SqlDataSource_TA"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>



                            <asp:TemplateField HeaderText="启蒙班讲员">
                                <ItemTemplate>
                                    <%# Eval("[CL02-Speaker]") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditSpeaker_CL02" runat="server"
                                        DataSourceID="SqlDataSource_Speaker"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="启蒙班：协助">
                                <ItemTemplate>
                                    <%# Eval("[CL02-Assistant]") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditTA_CL02" runat="server"
                                        DataSourceID="SqlDataSource_TA"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>



                            <asp:TemplateField HeaderText="初小班讲员">
                                <ItemTemplate>
                                    <%# Eval("[CL03-Speaker]") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditSpeaker_CL03" runat="server"
                                        DataSourceID="SqlDataSource_Speaker"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="初小班：协助">
                                <ItemTemplate>
                                    <%# Eval("[CL03-Assistant]") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditTA_CL03" runat="server"
                                        DataSourceID="SqlDataSource_TA"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>



                            <asp:TemplateField HeaderText="中小班讲员">
                                <ItemTemplate>
                                    <%# Eval("[CL04-Speaker]") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditSpeaker_CL04" runat="server"
                                        DataSourceID="SqlDataSource_Speaker"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="中小班：协助">
                                <ItemTemplate>
                                    <%# Eval("[CL04-Assistant]") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditTA_CL04" runat="server"
                                        DataSourceID="SqlDataSource_TA"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>



                            <asp:TemplateField HeaderText="查经班讲员">
                                <ItemTemplate>
                                    <%# Eval("[CL05-Speaker]") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditSpeaker_CL05" runat="server"
                                        DataSourceID="SqlDataSource_Speaker"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="查经班：协助">
                                <ItemTemplate>
                                    <%# Eval("[CL05-Assistant]") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditTA_CL05" runat="server"
                                        DataSourceID="SqlDataSource_TA"
                                        AppendDataBoundItems="True"
                                        DataTextField="Name"
                                        DataValueField="staff_id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                        <FooterStyle BackColor="#CCCCCC" />
                        <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                        <SortedAscendingCellStyle BackColor="#F1F1F1" />
                        <SortedAscendingHeaderStyle BackColor="#808080" />
                        <SortedDescendingCellStyle BackColor="#CAC9C9" />
                        <SortedDescendingHeaderStyle BackColor="#383838" />
                    </asp:GridView>
                </div>

                <!-- DataSources to manage 2nd section-->
                <asp:SqlDataSource ID="SqlDataSource_Arrangement" runat="server"
                    ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                    SelectCommand="
                            SELECT
                                MAX(str.record_id) AS record_id,
                                act.schedule_id AS schedule_id,
                                act.activity_date AS Date,
                                a.activity_name AS Activity,
                                
                                MAX(CASE WHEN cl.class_id = 'CL00' AND str.serviceList_id = 'SL-03' THEN p.chinese_name END) AS [CL00-Pianist],
                                MAX(CASE WHEN cl.class_id = 'CL00' AND str.serviceList_id = 'SL-05' THEN p.chinese_name END) AS [CL00-SongLeader1],
                                MAX(CASE WHEN cl.class_id = 'CL00' AND str.serviceList_id = 'SL-06' THEN p.chinese_name END) AS [CL00-SongLeader2],
                                MAX(CASE WHEN cl.class_id = 'CL00' AND str.serviceList_id = 'SL-07' THEN p.chinese_name END) AS [CL00-Theory],
                                MAX(CASE WHEN cl.class_id = 'CL00' AND str.serviceList_id = 'SL-02' THEN p.chinese_name END) AS [CL00-Prayer],

                                -- CL01 幼儿班
                                MAX(CASE WHEN cl.class_id = 'CL01' AND str.serviceList_id = 'SL-04' THEN p.chinese_name END) AS [CL01-Speaker],
                                MAX(CASE WHEN cl.class_id = 'CL01' AND str.serviceList_id = 'SL-01' THEN p.chinese_name END) AS [CL01-Assistant],

                                -- CL02 启蒙班
                                MAX(CASE WHEN cl.class_id = 'CL02' AND str.serviceList_id = 'SL-04' THEN p.chinese_name END) AS [CL02-Speaker],
                                MAX(CASE WHEN cl.class_id = 'CL02' AND str.serviceList_id = 'SL-01' THEN p.chinese_name END) AS [CL02-Assistant],

                                -- CL03 初小班
                                MAX(CASE WHEN cl.class_id = 'CL03' AND str.serviceList_id = 'SL-04' THEN p.chinese_name END) AS [CL03-Speaker],
                                MAX(CASE WHEN cl.class_id = 'CL03' AND str.serviceList_id = 'SL-01' THEN p.chinese_name END) AS [CL03-Assistant],
    
                                -- CL03 中小班
                                MAX(CASE WHEN cl.class_id = 'CL04' AND str.serviceList_id = 'SL-04' THEN p.chinese_name END) AS [CL04-Speaker],
                                MAX(CASE WHEN cl.class_id = 'CL04' AND str.serviceList_id = 'SL-01' THEN p.chinese_name END) AS [CL04-Assistant],
    
                                -- CL03 故事班
                                MAX(CASE WHEN cl.class_id = 'CL05' AND str.serviceList_id = 'SL-04' THEN p.chinese_name END) AS [CL05-Speaker],
                                MAX(CASE WHEN cl.class_id = 'CL05' AND str.serviceList_id = 'SL-01' THEN p.chinese_name END) AS [CL05-Assistant]

                            FROM activitySchedule act
                            INNER JOIN activity a ON act.activity_id = a.activity_id
                            LEFT JOIN staffTeachingRecord str ON str.schedule_id = act.schedule_id
                            LEFT JOIN class cl ON cl.class_id = str.class_id
                            LEFT JOIN staff s ON s.staff_id = str.staff_id
                            LEFT JOIN person p ON p.person_id = s.person_id
                            WHERE str.class_id IS NOT NULL
                            AND a.activity_name != '儿童诗班'
                            AND (YEAR(act.activity_date) = @Year OR @Year = 0)
                            AND (@HalfYear = 0 
                                 OR (@HalfYear = 1 AND MONTH(act.activity_date) BETWEEN 1 AND 6)
                                 OR (@HalfYear = 2 AND MONTH(act.activity_date) BETWEEN 7 AND 12))
                            GROUP BY 
                                act.schedule_id,
                                act.activity_date,
                                a.activity_name
                            ORDER BY act.activity_date ASC;">
                    <SelectParameters>
                        <asp:Parameter Name="Year" Type="Int32" />
                        <asp:Parameter Name="HalfYear" Type="Int32" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>
 </form>
</body>
</html>