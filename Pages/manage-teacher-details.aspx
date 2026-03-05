<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="manage-teacher-details.aspx.vb" Inherits="sunday_school_ms.manage_teacher_details" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Manage Teacher Details</title>
    <style>
        table {border-collapse: collapse;width: auto;}
        th, td {border: 1px solid #ccc;padding: 8px;text-align:center;}
        .role-radio-list input[type="radio"] { margin-right: 6px;}
        .role-radio-list label {font-size: 16px;margin-bottom: 8px;display: block;cursor: pointer;}
    </style>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="menu-container">
        <div class="right-menu-container">
            <div class="filter-menu">
                <div class="filter-wrapper">
                    <h3>老师资料管理</h3>
                    <asp:Button ID="BtnReturn" runat="server" CssClass="btn-normal" Style="border-radius: 5px;" Text="⏎ 回去" />
                </div>
            </div>
            <hr />
            <div class="filter-menu">
                <div class="filter-wrapper">
                    <asp:RadioButtonList ID="rblSearchRole" runat="server"
                        DataSourceID="SqlDataSource_Roles"
                        DataTextField="role_chinese"
                        DataValueField="role_english"
                        AutoPostBack="True"
                        CssClass="pill-radio"
                        RepeatDirection="Horizontal"
                        RepeatLayout="Flow"
                        AppendDataBoundItems="True">
                        <asp:ListItem Text="全部" Value="ALL" Selected="True"></asp:ListItem>
                    </asp:RadioButtonList>
                    <h6 style="color:red;margin: 10px;">请选择 Edit 编辑。可选择 ✔ 以更新个人地址与服事项目。</h6>
                </div>
                <div class="filter-wrapper">
                    
                </div>
            </div>
        <br />
        <asp:GridView ID="GridView_Teacher" runat="server" CssClass="my-grid"
            AllowPaging="True" PageSize="30" AllowSorting="True" AutoGenerateColumns="False"
            BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
            CellPadding="3" DataSourceID="SqlDataSource_teacherArrangement"
            ForeColor="Black" GridLines="Vertical" Width="100%"
            DataKeyNames="staff_id">
            <Columns>
                <asp:CommandField ShowEditButton="True" HeaderText="编辑" SelectText="Edit" ItemStyle-Width="50px" />
                <asp:CommandField ShowSelectButton="True" HeaderText="更多" SelectText="✔" ItemStyle-Width="50px" />
                <asp:TemplateField HeaderText="角色" ItemStyle-Width="80px">
                    <ItemTemplate>
                        <%# 
                                    If(Eval("role").ToString() = "Principal", "校长",
                                                            If(Eval("role").ToString() = "Teacher", "老师",
                                                If(Eval("role").ToString() = "Teaching Assistants", "助教", Eval("role").ToString()))) 
                        %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlRole" runat="server"
                            DataSourceID="SqlDataSource_Roles"
                            DataTextField="role_chinese"
                            DataValueField="role_english"
                            SelectedValue='<%# Bind("role") %>'>
                            <asp:ListItem Text="- 角色选择 -" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="first_name" HeaderText="姓名(英)">
                    <ItemStyle Width="200px"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="last_name" HeaderText="姓氏(英)" SortExpression="last_name">
                    <ItemStyle Width="100px"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="chinese_name" HeaderText="姓名(中)">
                    <ItemStyle Width="100px"></ItemStyle>
                </asp:BoundField>
                <asp:TemplateField HeaderText="联络号码" HeaderStyle-Width="150">
                    <ItemTemplate><%# FormatContact(Eval("contact_no")) %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtContactNo" runat="server" Text='<%# Bind("contact_no") %>' Width="120px"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="性别" HeaderStyle-Width="50" SortExpression="gender">
                    <ItemTemplate><%# If(Eval("gender").ToString() = "1", "男", "女") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlGender" runat="server" SelectedValue='<%# Bind("gender") %>'>
                            <asp:ListItem Text="男" Value="1" />
                            <asp:ListItem Text="女" Value="2" />
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="出生日期" ItemStyle-Width="100px" SortExpression="dob_month">
                    <ItemTemplate>
                        <%# Eval("dob", "{0:dd-MM-yyyy}") %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtDOB" runat="server" ItemStyle-Width="80px" Text='<%# Bind("dob", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="date-picker" />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="email" HeaderText="电邮" ItemStyle-Width="300px" ReadOnly="False" />



            </Columns>
            <FooterStyle BackColor="#CCCCCC" />
            <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" Font-Underline="False" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#FFE9A7" Font-Bold="False" ForeColor="Black" CssClass="selectedRow" />
            <SortedAscendingCellStyle BackColor="" />
            <SortedAscendingHeaderStyle BackColor="#CAC9C9" />
            <SortedDescendingCellStyle BackColor="#F1F1F1" />
            <SortedDescendingHeaderStyle BackColor="#383838" />
        </asp:GridView>

        <asp:SqlDataSource ID="SqlDataSource_Roles" runat="server"
            ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
            SelectCommand="
                       SELECT DISTINCT 
                        role AS role_english,
                        CASE 
                            WHEN role = 'Principal' THEN '校长'
                            WHEN role = 'Teacher' THEN '老师'
                            WHEN role = 'Teaching Assistants' THEN '助教'
                            ELSE role
                        END AS role_chinese
                    FROM staff
                    ORDER BY role_english"></asp:SqlDataSource>

        <asp:SqlDataSource
            ID="SqlDataSource_teacherArrangement" runat="server" ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
            SelectCommand="
                    SELECT 
                        p.person_id, p.last_name, p.first_name, p.chinese_name, p.contact_no, p.gender, p.dob, p.age, a.address_id,
                        s.staff_id, s.email, s.status, s.role,
                        MONTH(p.dob) AS dob_month,
                        DAY(p.dob) AS dob_day
                    FROM person_roles p
                    INNER JOIN address a ON p.address_id = a.address_id
                    INNER JOIN staff s ON p.person_id = s.person_id
                    WHERE (@role = 'ALL' OR s.role = @role) AND p.isTeacher = 1 AND s.status = 'Active'
                    ORDER BY MONTH(p.dob), DAY(p.dob)"
            UpdateCommand="
                    UPDATE person_roles
                    SET 
                        first_name=@first_name,
                        last_name=@last_name,
                        chinese_name=@chinese_name,
                        contact_no=@contact_no,
                        gender=@gender,
                        dob=@dob
                    WHERE person_id = (SELECT person_id FROM staff WHERE staff_id=@staff_id);

                    UPDATE staff
                    SET 
                        email=@email,
                        role=@role
                    WHERE staff_id=@staff_id;">
            <SelectParameters>
                <asp:ControlParameter Name="role" ControlID="rblSearchRole" PropertyName="SelectedValue" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="first_name" Type="String" />
                <asp:Parameter Name="last_name" Type="String" />
                <asp:Parameter Name="chinese_name" Type="String" />
                <asp:Parameter Name="contact_no" Type="String" />
                <asp:Parameter Name="gender" Type="String" />
                <asp:Parameter Name="dob" Type="DateTime" />
                <asp:Parameter Name="email" Type="String" />
                <asp:Parameter Name="role" Type="String" />
                <asp:Parameter Name="staff_id" Type="String" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <br />
        <asp:Panel ID="pnlActionButtons" runat="server" Visible="False">
            <asp:Button ID="BtnUpdateAddress" runat="server" Text="地址更新" CssClass="btn-normal" OnClick="BtnUpdateAddress_Click" />
            <asp:Button ID="BtnUpdateService" runat="server" Text="事奉项目更新" CssClass="btn-normal" OnClick="BtnUpdateService_Click" />
        </asp:Panel>
        </div>
    </div>
</asp:Content>