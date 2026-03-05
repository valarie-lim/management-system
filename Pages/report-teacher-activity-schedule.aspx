<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="report-teacher-activity-schedule.aspx.vb" Inherits="sunday_school_ms.report_teacher_activity_schedule" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Teacher and Activity Schedule</title>
    <link runat="server" rel="stylesheet" href="../CSS/style.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet" />
    <style>
        .WideGridview {white-space: nowrap;}
        table.WideGridview td, table.WideGridview th {padding: 8px !important;}
        .WideGridview th {position: sticky;top: 0;background: black;z-index: 2;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header id="main-header">
            <div class="header-left">
                <a href="#" class="logo-style">
                    <img src="../Images/logo.png"/></a>
                <h3>Teacher and Activity Schedule</h3>
            </div>
            <div class="header-right">
                <ul class="navlist">
                    <li><span id="LiveClock" class="timestamp-font-size"></span></li>
                </ul>
                <asp:Button ID="BtnReturn" runat="server"
                    CssClass="btn-normal"
                    Style="border-radius: 5px;" Text="Return to Dashboard"/>

            </div>
        </header>
        <br />
        <!-- main content -->
        <div class="menu-container">
            <div class="right-menu-container">
                <div class="filter-menu">
                    <div class="filter-wrapper">
                        <asp:Label ID="lblScheduleType" runat="server" Text="Schedule:" />
                        <asp:DropDownList ID="ddlScheduleType" runat="server" CssClass="filter-txtbox" AutoPostBack="true">
                        </asp:DropDownList>

                        <asp:Label ID="lblYear" runat="server" Text="Year:" />
                        <asp:DropDownList ID="ddlYear" runat="server" CssClass="filter-txtbox"></asp:DropDownList>

                        <asp:Label ID="lblHalf" runat="server" Text="Period:" Visible="False" />
                        <asp:DropDownList ID="ddlHalf" runat="server" CssClass="filter-txtbox" Visible="False">
                            <asp:ListItem Text="Jan - Jun" Value="1" />
                            <asp:ListItem Text="Jul - Dec" Value="2" />
                        </asp:DropDownList>
                        <asp:Button ID="BtnFilter" runat="server" Text="Filter" CssClass="btn-filter" />
                        <asp:Button ID="BtnExportPDF" runat="server" Text="Save as PDF" CssClass="btn-filter" />
                    </div>
                </div>
                <br />
                <!-- Gridview -->
                <div style="overflow-x: auto; width: 100%;">
                    <asp:GridView ID="GridView_Arrangement" runat="server"
                        AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                        BackColor="White" BorderColor="#999999" BorderStyle="Solid"
                        BorderWidth="1px" CellPadding="3"
                        ForeColor="Black" GridLines="Vertical" PageSize="15" CssClass="WideGridview">

                        <AlternatingRowStyle BackColor="#CCCCCC" />

                        <Columns>
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <%# Eval("Date", "{0:yyyy-MM-dd}") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="Activity">
                                <ItemTemplate>
                                    <%# Eval("Activity") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="S.L.">
                                <ItemTemplate>
                                    <%# Eval("Song Leader") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="S.L.TA">
                                <ItemTemplate>
                                    <%# Eval("Song TA") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Pianist">
                                <ItemTemplate>
                                    <%# Eval("Pianist") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Prayer">
                                <ItemTemplate>
                                    <%# Eval("Prayer") %>
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Material">
                                <ItemTemplate>
                                    <%# Eval("Material") %>
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="S 0-4Y">
                                <ItemTemplate>
                                    <%# Eval("[S-01]") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="TA 0-4Y">
                                <ItemTemplate>
                                    <%# Eval("[TA-01]") %>
                                </ItemTemplate>
                            </asp:TemplateField>



                            <asp:TemplateField HeaderText="S 5-6Y">
                                <ItemTemplate>
                                    <%# Eval("[S-02]") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="TA 5-6Y">
                                <ItemTemplate>
                                    <%# Eval("[TA-02]") %>
                                </ItemTemplate>
                            </asp:TemplateField>



                            <asp:TemplateField HeaderText="S 7-8Y">
                                <ItemTemplate>
                                    <%# Eval("[S-03]") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="TA 7-8Y">
                                <ItemTemplate>
                                    <%# Eval("[TA-03]") %>
                                </ItemTemplate>
                            </asp:TemplateField>



                            <asp:TemplateField HeaderText="S 9-10Y">
                                <ItemTemplate>
                                    <%# Eval("[S-04]") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="TA 9-10Y">
                                <ItemTemplate>
                                    <%# Eval("[TA-04]") %>
                                </ItemTemplate>
                            </asp:TemplateField>



                            <asp:TemplateField HeaderText="S 11-12Y">
                                <ItemTemplate>
                                    <%# Eval("[S-05]") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="TA 11-12Y">
                                <ItemTemplate>
                                    <%# Eval("[TA-05]") %>
                                </ItemTemplate>
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
            </div>
        </div>
 </form>
    </body>
</html>