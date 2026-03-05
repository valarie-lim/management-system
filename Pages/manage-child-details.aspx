<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="manage-child-details.aspx.vb" Inherits="sunday_school_ms.manage_child_details" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <style>
        table {border-collapse: collapse;width: auto;}
        th, td {border: 1px solid #ccc;padding: 8px;}
        .scroll-container {width: 100%;overflow-x: auto;}
        .my-grid {min-width: 1500px;table-layout: fixed; text-align:center;}
    </style>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="menu-container">
        <div class="right-menu-container">
            <div class="filter-menu">
                <div class="filter-wrapper">
                    <h5>儿童资料管理</h5>
                    <asp:Button ID="BtnReturn" runat="server" CssClass="btn-normal" Style="border-radius: 5px;" Text="⏎ 回去" />
                </div>
            </div>
            <hr />
            <div class="filter-menu">
                <div class="filter-wrapper">
                    <asp:Label ID="lblClass" runat="server" Text="班级:" AssociatedControlID="ddlSearchClass" />
                    <asp:DropDownList ID="ddlSearchClass" runat="server" CssClass="filter-txtbox"
                        DataSourceID="SqlDataSource_ClassList"
                        DataTextField="class_name"
                        DataValueField="class_id"
                        AutoPostBack="true"
                        AppendDataBoundItems="True">
                        <asp:ListItem Text="全部" Value="ALL" Selected="True"></asp:ListItem>
                    </asp:DropDownList>
                    <button class="btn-filter" type="button" onclick="navigateTo('add-new-person.aspx')">添加家长</button>
                    <button class="btn-filter" type="button" onclick="navigateTo('manage-guardian-details.aspx')">管理家长资料</button>
                </div>

            </div>
            <br />

            <!-- GridView -->
            <div class="scroll-container">
                <asp:GridView ID="GridView_Child" runat="server" CssClass="my-grid"
                    AllowPaging="True" PageSize="30" AllowSorting="True" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
                    CellPadding="3" DataSourceID="SqlDataSource_childInfo"
                    ForeColor="Black" GridLines="Vertical"
                    DataKeyNames="child_id">

                    <AlternatingRowStyle BackColor="#CCCCCC" />

                    <Columns>
                        <asp:CommandField ShowEditButton="True" EditText="Edit" CancelText="Cancel" UpdateText="Update" HeaderStyle-Width="80">
                            <HeaderStyle Width="80px"></HeaderStyle>
                        </asp:CommandField>
                        <asp:BoundField DataField="first_name" HeaderText="姓名(英)">
                            <ItemStyle Width="250px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="last_name" HeaderText="姓氏(英)" SortExpression="last_name">
                            <ItemStyle Width="120px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="chinese_name" HeaderText="姓名(中)">
                            <ItemStyle Width="120px"></ItemStyle>
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="性别" HeaderStyle-Width="100">
                            <ItemTemplate>
                                <%# If(Eval("gender").ToString()="1","男","女") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlGender" runat="server" SelectedValue='<%# Bind("gender") %>'>
                                    <asp:ListItem Text="男" Value="1" />
                                    <asp:ListItem Text="女" Value="2" />
                                </asp:DropDownList>
                            </EditItemTemplate>

                            <HeaderStyle Width="100px"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="出生日期" HeaderStyle-Width="150" SortExpression="dob_month">
                            <ItemTemplate>
                                <%# Eval("dob", "{0:dd-MM-yyyy}") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtDOB" runat="server" Text='<%# Bind("dob", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="date-picker" />
                            </EditItemTemplate>

                            <HeaderStyle Width="150px"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:BoundField DataField="age" HeaderText="年龄" SortExpression="age" ReadOnly="True">
                            <ItemStyle Width="80px"></ItemStyle>
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="信仰" HeaderStyle-Width="150">
                            <ItemTemplate><%# If(Eval("religion").ToString()="1","基督徒","非基督徒") %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlReligion" runat="server" SelectedValue='<%# Bind("religion") %>'>
                                    <asp:ListItem Text="基督徒" Value="1" />
                                    <asp:ListItem Text="非基督徒" Value="0" />
                                </asp:DropDownList>
                            </EditItemTemplate>

                            <HeaderStyle Width="150px"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:BoundField DataField="joined_date" HeaderText="第一次参与" DataFormatString="{0:dd-MM-yyyy}" ReadOnly="False">
                            <ItemStyle Width="150px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="inviter" HeaderText="邀请者" ReadOnly="False">
                            <ItemStyle Width="100px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="school" HeaderText="学校" ReadOnly="False">
                            <ItemStyle Width="400px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="church" HeaderText="所属教会" ReadOnly="False">
                            <ItemStyle Width="400px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="remark" HeaderText="备注" ReadOnly="False">
                            <ItemStyle Width="450px"></ItemStyle>
                        </asp:BoundField>
                    </Columns>
                    <EditRowStyle BackColor="#FFE9A7" />
                    <FooterStyle BackColor="#FFE9A7" />
                    <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#FFE9A7" Font-Bold="False" ForeColor="Black" CssClass="selectedRow" />
                    <SortedAscendingCellStyle BackColor="" />
                    <SortedAscendingHeaderStyle BackColor="#CAC9C9" />
                    <SortedDescendingCellStyle BackColor="#F1F1F1" />
                    <SortedDescendingHeaderStyle BackColor="#383838" />
                </asp:GridView>
            </div>

            <!-- Data Source Class -->
            <asp:SqlDataSource ID="SqlDataSource_ClassList" runat="server"
                ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                SelectCommand="SELECT class_id, class_name FROM class WHERE class_id != 'CL00' ORDER BY class_id;"></asp:SqlDataSource>

            <!-- Data Source Child and Class -->
            <asp:SqlDataSource ID="SqlDataSource_childInfo" runat="server"
                ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                SelectCommand="
                        SELECT
                            c.child_id, c.first_name, c.last_name, c.chinese_name,
                            c.dob, c.gender, c.age, c.isArchive,
                            c.religion, c.joined_date, c.inviter, c.school, c.church, c.remark,
                            cl.class_name,
                            MONTH(c.dob) AS dob_month,
                            DAY(c.dob) AS dob_day
                              FROM child c
                        LEFT JOIN class cl ON c.class_id=cl.class_id
                        WHERE (@class_id ='ALL' OR c.class_id = @class_id)
                        AND c.isArchive = 0
                        ORDER BY MONTH(c.dob), DAY(c.dob)"
                UpdateCommand="
                        UPDATE child
                        SET first_name=@first_name,
                            last_name=@last_name,
                            chinese_name=@chinese_name,
                            dob=@dob,
                            gender=@gender,
                            religion=@religion,
                            joined_date=@joined_date,
                            inviter=@inviter,
                            school=@school,
                            church=@church,
                            remark=@remark
                        WHERE child_id=@child_id;

                    ">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlSearchClass" Name="class_id" PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="first_name" Type="String" />
                    <asp:Parameter Name="last_name" Type="String" />
                    <asp:Parameter Name="chinese_name" Type="String" />
                    <asp:Parameter Name="dob" Type="DateTime" />
                    <asp:Parameter Name="gender" Type="String" />
                    <asp:Parameter Name="religion" Type="String" />
                    <asp:Parameter Name="joined_date" Type="DateTime" />
                    <asp:Parameter Name="inviter" Type="String" />
                    <asp:Parameter Name="school" Type="String" />
                    <asp:Parameter Name="church" Type="String" />
                    <asp:Parameter Name="remark" Type="String" />
                    <asp:Parameter Name="isArchive" Type="String" />
                    <asp:Parameter Name="child_id" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>

        </div>
    </div>
</asp:Content>
