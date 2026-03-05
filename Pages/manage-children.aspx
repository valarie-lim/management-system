<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="manage-children.aspx.vb" Inherits="sunday_school_ms.manage_children" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Children Management</title>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <section>
            <div class="menu-container">
                <div class="side-menu-container" onclick="event.stopPropagation()">
                    <button class="btn-menu" style="margin-top:50px;" type="button" onclick="navigateTo('admin-dashboard.aspx')">主界面</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-children.aspx')">儿童与家长管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-teacher.aspx')">老师管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-activity.aspx')">活动管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-materials.aspx')">材料管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-users.aspx')">系统用户管理</button>
                </div>

                <!-- Main content inside form -->
                <div class="right-menu-container">
                    <h3>儿童管理</h3>
                    <hr />
                    <div class="filter-menu">
                        <div class="filter-wrapper">
                            <button type="button" onclick="navigateTo('add-new-child.aspx')">添加儿童</button>
                            <button type="button" style="width:25%" onclick="navigateTo('manage-child-details.aspx')">更新资料 / 整理家长资料</button>
                        </div>
                        <br />
                        <div class="filter-wrapper">
                            <asp:Label ID="lblActive" runat="server" Text="状态:" AssociatedControlID="ddlSearchActive" />
                            <asp:DropDownList ID="ddlSearchActive" runat="server" CssClass="filter-txtbox"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ddlSearchActive_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <br />
                    <asp:GridView ID="GridView_Child" runat="server" CssClass="my-grid"
                        AllowPaging="True" PageSize="60" AllowSorting="True" AutoGenerateColumns="False"
                        BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
                        CellPadding="3" DataSourceID="SqlDataSource_childInfo"
                        ForeColor="Black" GridLines="Vertical" Width="100%"
                        DataKeyNames="child_id">
                        <AlternatingRowStyle BackColor="#CCCCCC" />
                        <Columns>
                            <asp:BoundField DataField="EnglishName" HeaderText="姓名(英)" SortExpression="EnglishName" ReadOnly="True">
                                <ItemStyle Width="300px"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="chinese_name" HeaderText="姓名(中)" ReadOnly="True">
                                <ItemStyle Width="100px"></ItemStyle>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="性别" HeaderStyle-Width="100" SortExpression="gender" >
                                <ItemTemplate>
                                    <%# If(Eval("gender").ToString()="1","男","女") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="age" HeaderText="年龄" SortExpression="age" ReadOnly="True">
                                <ItemStyle Width="80px"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="class_name" HeaderText="班级" SortExpression="class_name" ReadOnly="True">
                                <ItemStyle Width="80px"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="Guardians" HeaderText="家长" ReadOnly="True">
                                <ItemStyle Width="150px"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="ArchiveStatus" HeaderText="状态" SortExpression="ArchiveStatus" ReadOnly="True">
                                <ItemStyle Width="80px"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="PassbyStatus" HeaderText="路过" SortExpression="PassbyStatus" ReadOnly="True">
                                <ItemStyle Width="80px"></ItemStyle>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Archive" HeaderStyle-Width="100">
                                <ItemTemplate>
                                    <asp:Button ID="btnArchive" runat="server"
                                        Text="设置 / 取消"
                                        CommandName="Archive"
                                        CommandArgument='<%# Eval("child_id") %>'
                                        CssClass="btn-selection" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Pass By" HeaderStyle-Width="100">
                                <ItemTemplate>
                                    <asp:Button ID="btnPassby" runat="server"
                                        Text="设置 / 取消"
                                        CommandName="PassBy"
                                        CommandArgument='<%# Eval("child_id") %>'
                                        CssClass="btn-selection" />
                                </ItemTemplate>
                            </asp:TemplateField>

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

                    <asp:SqlDataSource ID="SqlDataSource_childInfo" runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT 
                                c.child_id,
                                (c.first_name + ' ' + c.last_name) AS EnglishName,
                                c.chinese_name,
                                c.gender,
                                c.age,
                                STRING_AGG(p.chinese_name + ' (' + p.contact_no + ')', ', ') 
                                WITHIN GROUP (ORDER BY re.guardian_id) AS Guardians,
                                CASE
                                    WHEN c.isPassing = 1 THEN 'Yes'
                                    WHEN c.isPassing = 0 THEN ''
                                    END AS PassbyStatus, 
                                CASE 
                                    WHEN c.isArchive = 1 THEN '已归档'
                                    ELSE '活跃'
                                END AS ArchiveStatus,
                                cl.class_name,
                                cl.classroom
                            FROM child c
                            INNER JOIN class cl ON c.class_id = cl.class_id
                            LEFT JOIN relationship re ON c.child_id = re.child_id
                            LEFT JOIN guardian g ON re.guardian_id = g.guardian_id
                            LEFT JOIN person p ON g.person_id = p.person_id
                        WHERE
                            (
                                @isArchive = 'all' OR
                                (@isArchive = '0' AND c.isArchive = 0) OR
                                (@isArchive = '1' AND c.isArchive = 1) OR
                                (@isArchive = '2' AND YEAR(c.joined_date) = YEAR(GETDATE())) OR
                                (@isArchive = '3' AND c.isPassing = 1)
                            ) 
                        GROUP BY c.child_id, c.first_name, c.last_name, c.chinese_name,
                        c.gender, c.age, c.isPassing, c.isArchive,
                        cl.class_name, cl.classroom
                        ">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ddlSearchActive" Name="isArchive" PropertyName="SelectedValue" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
        </section>
</asp:Content>