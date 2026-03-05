<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="activate-account.aspx.vb" Inherits="sunday_school_ms.activate_account" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Activate Account</title>
    <style>
        table {border-collapse: collapse;width: 100%;}
        th, td {border: 1px solid #ccc;padding: 8px;}
    </style>
    </asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="menu-container">
        <div class="right-menu-container">
            <div class="filter-menu">
                <div class="filter-wrapper">
                    <asp:Button ID="BtnReturn" runat="server" CssClass="btn-return" Text="⏎ 回去" />
                    <asp:Button ID="BtnDashboard" runat="server" CssClass="btn-return" Text="回主界面" />
                </div>
                <br />
                    <h4>激活账号</h4>
            </div>
            <hr />
            <h6>搜索用户的名字，点击 ‘Send’ 发送重新激活邮件。</h6>
            <div class="filter-menu">
                <div class="filter-wrapper">
                    <asp:TextBox ID="txtSearchName" runat="server" CssClass="filter-txtbox"
                        Placeholder="输入用户的名字" Width="250px"></asp:TextBox>
                    <asp:Button ID="BtnSearch" runat="server" Text="搜寻" CssClass="btn-filter" OnClick="BtnSearch_Click" />
                </div>
            </div>
            <br />

            <asp:GridView ID="GridView_EditUserInfo" runat="server" CssClass="my-grid"
                AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
                CellPadding="3" DataSourceID="SqlDataSource_editUserInfo"
                ForeColor="Black" GridLines="Vertical" Width="90%"
                DataKeyNames="user_id">

                <AlternatingRowStyle BackColor="#CCCCCC" />
                <Columns>
                    <asp:BoundField DataField="staff_id" HeaderText="ID" ReadOnly="True" Visible="False">
                        <ItemStyle Width="100px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="first_name" HeaderText="名字（英）" ReadOnly="True">
                        <ItemStyle Width="300px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="chinese_name" HeaderText="名字（中）" ReadOnly="True">
                        <ItemStyle Width="150px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="email" HeaderText="电邮" ReadOnly="True">
                        <ItemStyle Width="350px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="acc_status" HeaderText="账号状态" ReadOnly="False">
                        <ItemStyle Width="350px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="failed_attempts" HeaderText="登陆尝试" ReadOnly="False">
                        <ItemStyle Width="150px"></ItemStyle>
                    </asp:BoundField>
                    <asp:CommandField ShowSelectButton="True" HeaderText="激活链接" SelectText="Send">
                        <ItemStyle Width="150px"></ItemStyle>
                    </asp:CommandField>
                </Columns>
                <FooterStyle BackColor="#CCCCCC" />
                <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="#FFE9A7" Font-Bold="False" ForeColor="Black" CssClass="selectedRow" />
                <SortedAscendingCellStyle BackColor="" />
                <SortedAscendingHeaderStyle BackColor="#CAC9C9" />
                <SortedDescendingCellStyle BackColor="#F1F1F1" />
                <SortedDescendingHeaderStyle BackColor="#383838" />
            </asp:GridView>

            <asp:SqlDataSource ID="SqlDataSource_editUserInfo" runat="server"
                ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                SelectCommand="
                            SELECT l.user_id, s.staff_id, p.first_name, p.chinese_name, s.email, l.acc_status, l.failed_attempts
                            FROM person p
                            INNER JOIN staff s ON p.person_id = s.person_id
                            INNER JOIN login l ON s.staff_id = l.user_id
                            WHERE 
                            (
                                LOWER(LTRIM(RTRIM(p.first_name))) LIKE '%' + LOWER(LTRIM(RTRIM(@first_name))) + '%'
                                OR
                                LOWER(LTRIM(RTRIM(p.chinese_name))) LIKE '%' + LOWER(LTRIM(RTRIM(@chinese_name))) + '%'
                            )
                                AND s.isAdmin = 1 AND l.acc_status = 'locked'
                            ">
                <SelectParameters>
                    <asp:ControlParameter Name="first_name" ControlID="txtSearchName" PropertyName="Text" Type="String" />
                    <asp:ControlParameter Name="chinese_name" ControlID="txtSearchName" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
