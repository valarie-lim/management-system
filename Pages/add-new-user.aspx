<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="add-new-user.aspx.vb" Inherits="sunday_school_ms.add_new_user" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Add New User</title>
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
                    <h5>添加系统用户</h5>
                    <asp:Button ID="BtnReturn" runat="server" CssClass="btn-normal" Style="border-radius: 5px;" Text="⏎ 回去" />
                </div>
            </div>
            <hr />
            <h6 style="color: red;">点击 ‘Send’ 向该教师发送注册链接邮件。</h6>
            <br />
            <asp:GridView ID="GridView_AddUser" runat="server" CssClass="my-grid"
                AllowPaging="True" PageSize="30" AllowSorting="True" AutoGenerateColumns="False"
                BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
                CellPadding="3" DataSourceID="SqlDataSource_editUserInfo"
                ForeColor="Black" Width="90%"
                DataKeyNames="staff_id" GridLines="Vertical">
                <AlternatingRowStyle BackColor="#CCCCCC" />
                <Columns>
                    <asp:BoundField DataField="staff_id" HeaderText="教师 ID" ReadOnly="True" Visible="False">
                        <ItemStyle Width="100px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="first_name" HeaderText="名字（英）" ReadOnly="True">
                        <ItemStyle Width="300px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="chinese_name" HeaderText="名字（中）" ReadOnly="True">
                        <ItemStyle Width="150px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="role" HeaderText="职位" ReadOnly="True">
                        <ItemStyle Width="300px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="email" HeaderText="电邮" ReadOnly="True">
                        <ItemStyle Width="350px"></ItemStyle>
                    </asp:BoundField>
                    <asp:CommandField ShowSelectButton="True" HeaderText="注册链接" SelectText="Send">
                        <ItemStyle Width="180px"></ItemStyle>
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

            <asp:SqlDataSource
                ID="SqlDataSource_editUserInfo"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                SelectCommand="
                            SELECT s.staff_id, p.first_name, p.chinese_name, s.email, s.role, s.isAdmin
                            FROM person p
                            INNER JOIN staff s ON p.person_id = s.person_id
                            WHERE s.isAdmin = 0 "></asp:SqlDataSource>
        </div>
    </div>
</asp:Content>