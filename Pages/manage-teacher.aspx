
<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="manage-teacher.aspx.vb" Inherits="sunday_school_ms.manage_teacher" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Teacher Management</title>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
            <div class="menu-container">
                <div class="side-menu-container" onclick="event.stopPropagation()">
                    <button class="btn-menu" style="margin-top:50px;" type="button" onclick="navigateTo('admin-dashboard.aspx')">主界面</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-children.aspx')">儿童与家长管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-teacher.aspx')">老师管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-activity.aspx')">活动管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-materials.aspx')">材料管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-users.aspx')">系统用户管理</button>
                </div>
                <div class="right-menu-container">
                    <h3>老师管理</h3>
                    <hr />
                    <div class="filter-menu">
                        <div class="filter-wrapper">
                            <button type="button" onclick="navigateTo('add-new-person.aspx')">添加新老师</button>
                            <button type="button" onclick="navigateTo('manage-teacher-details.aspx')">更新资料</button>
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
                    <asp:GridView ID="GridView_Teacher" runat="server" CssClass="my-grid"
                        AllowPaging="True" PageSize="60"  AllowSorting="True" AutoGenerateColumns="False"
                        BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
                        CellPadding="3" DataSourceID="SqlDataSource_editUserInfo"
                        ForeColor="Black" GridLines="Vertical" Width="100%"
                        DataKeyNames="person_id, staff_id">
                        <AlternatingRowStyle BackColor="#CCCCCC" />
                        <Columns>
                            <asp:BoundField DataField="full_name" HeaderText="姓名(英)" SortExpression="full_name" ReadOnly="True">
                                <ItemStyle Width="250px"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="chinese_name" HeaderText="姓名(中)" ReadOnly="True">
                                <ItemStyle Width="100px"></ItemStyle>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="联络号码">
                                <ItemTemplate>
                                    <%# Eval("contact_no").ToString().Substring(0, 3) + "-" + Eval("contact_no").ToString().Substring(3) %>
                                </ItemTemplate>
                                <ItemStyle Width="150px"></ItemStyle>
                            </asp:TemplateField>
                            <asp:BoundField DataField="role" HeaderText="角色" SortExpression="role" ReadOnly="True">
                                <ItemStyle Width="200px"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="ArchiveStatus" HeaderText="状态" SortExpression="ArchiveStatus" ReadOnly="True">
                                <ItemStyle Width="80px"></ItemStyle>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Archive" HeaderStyle-Width="100">
                                <ItemTemplate>
                                    <asp:Button ID="btnArchive" runat="server"
                                        Text="设置 / 取消"
                                        CommandName="ArchiveTeacher"
                                        CommandArgument='<%# Eval("staff_id") %>'
                                        CssClass="btn-selection" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Guardian" HeaderStyle-Width="100">
                                <ItemTemplate>
                                    <asp:Button ID="btnGuardian" runat="server"
                                        Text="设置 / 取消"
                                        CommandName="ToggleGuardian"
                                        CommandArgument='<%# Eval("staff_id") %>'
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
                    <asp:HiddenField ID="HiddenStaffID" runat="server" />

                    <!-- SqlDataSource -->
                    <asp:SqlDataSource ID="SqlDataSource_Children" runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT child_id, (chinese_name + '(' + first_name + ' ' + last_name +')') AS full_name 
                                FROM child ORDER BY full_name"></asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDataSource_editUserInfo" runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT
                                p.person_id,
                                (p.first_name + ' ' + p.last_name) AS full_name,
                                p.chinese_name, p.contact_no, p.gender, p.dob, p.age,
                                s.staff_id, s.status, s.role,
                                CASE 
                                    WHEN s.status = 'Active' THEN '活跃'
                                    ELSE '已归档'
                                END AS ArchiveStatus
                            FROM person p
                            INNER JOIN staff s ON p.person_id = s.person_id
                            WHERE
                                (
                                    (@status = 'Active' AND s.status = 'Active') OR
                                    (@status = 'Archived' AND s.status = 'Archived') OR
                                    (@status = 'All' )  -- Show all
                                ) 
                            ">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ddlSearchActive" Name="status" PropertyName="SelectedValue" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
            <!-- Guardian Popup Modal -->
            <div class="modal fade" id="GuardianModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content p-4">

                        <div class="modal-header">
                            <h5 class="modal-title">选择孩子与关系</h5>
                        </div>

                        <div class="modal-body">

                            <!-- Child Dropdown -->
                            <label>孩子*</label>
                            <asp:DropDownList ID="DdlChild" runat="server"
                                DataSourceID="SqlDataSource_Children"
                                DataTextField="full_name"
                                DataValueField="child_id"
                                CssClass="form-control">
                            </asp:DropDownList>

                            <br />

                            <!-- Relationship Dropdown -->
                            <label>关系*</label>
                            <asp:DropDownList ID="DdlRelationship" runat="server" CssClass="form-control">
                                <asp:ListItem></asp:ListItem>
                                <asp:ListItem>母亲</asp:ListItem>
                                <asp:ListItem>父亲</asp:ListItem>
                                <asp:ListItem>婆婆</asp:ListItem>
                                <asp:ListItem>公公</asp:ListItem>
                                <asp:ListItem>其他</asp:ListItem>
                            </asp:DropDownList>

                            <br />

                            <!-- Religion Dropdown -->
                            <label>信仰*</label>
                            <asp:DropDownList ID="DdlReligion" runat="server" CssClass="form-control">
                                <asp:ListItem></asp:ListItem>
                                <asp:ListItem>Christian</asp:ListItem>
                                <asp:ListItem>non-Christian</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="modal-footer">
                            <asp:Button ID="BtnSaveGuardian" runat="server" Text="确认" CssClass="btn-selection" />
                        </div>
                    </div>
                </div>
            </div> <!-- END Guardian Popup Modal -->
</asp:Content>