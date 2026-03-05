<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="manage-activity.aspx.vb" Inherits="sunday_school_ms.manage_activity" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Activity Management</title>
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

                <!-- Main content inside form -->
                <div class="right-menu-container">
                    <h3>活动管理</h3>
                    <hr />
                    
                    <div class="filter-menu">
                        <div class="filter-wrapper">
                            <button type="button" onclick="navigateTo('add-new-activity.aspx')">添加新活动</button>
                            <button type="button" onclick="navigateTo('add-new-material.aspx')">添加新材料</button>
                            <button type="button" onclick="navigateTo('schedule-arrangement.aspx')">事奉表安排</button>
                        </div>
                        <br />
                        <h6 style="text-align:left;"> 搜寻 年份 或 输入数字 0 显示全部活动(除了儿童诗班)</h6>
                        <div class="filter-wrapper">
                            <asp:TextBox ID="txtActivityYear" runat="server" Placeholder="年份搜寻。例子: 2025"
                                AutoPostBack="True" CssClass="filter-txtbox"
                                OnTextChanged="txtActivityYear_TextChanged">
                            </asp:TextBox>
                            <asp:Button ID="BtnSearch" runat="server" Text="搜寻" CssClass="btn-filter" />
                            
                        </div>
                    </div>
                    <br />
                    <div class="scroll-container">
                        <asp:GridView ID="GridView_Activity" runat="server" CssClass="my-grid"
                            AllowPaging="True" PageSize="60" AllowSorting="True" AutoGenerateColumns="False"
                            OnRowUpdating="GridView_Activity_RowUpdating" BackColor="White"
                            BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                            ForeColor="Black" GridLines="Vertical"
                            DataSourceID="SqlDataSource_viewActivity" DataKeyNames="schedule_id">

                            <AlternatingRowStyle BackColor="#CCCCCC" />

                            <Columns>
                                <asp:CommandField ShowEditButton="True" HeaderText="编辑"/>
                                <asp:TemplateField HeaderText="日期" SortExpression="activity_date">
                                    <ItemTemplate>
                                        <%# Eval("activity_date", "{0:yyyy-MM-dd}") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtActivityDate" runat="server" Text='<%# Bind("activity_date", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="date-picker"></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="活动" SortExpression="activity_name">
                                    <ItemTemplate>
                                        <%# Eval("activity_name") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlActivityName" runat="server"
                                            DataSourceID="SqlDataSource_ActivitiesList"
                                            DataTextField="activity_name"
                                            DataValueField="activity_id"
                                            SelectedValue='<%# Bind("activity_id") %>'>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="使用材料" SortExpression="display_text">
                                    <ItemTemplate>
                                        <%# Eval("display_text") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlMaterialName" runat="server"
                                            DataSourceID="SqlDataSource_MaterialsList"
                                            DataTextField="display_text"
                                            DataValueField="material_id"
                                            AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("material_id") %>'>
                                            <asp:ListItem Text="None" Value="None"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="#CCCCCC" />
                            <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                            <SelectedRowStyle BackColor="#FFE9A7" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="" />
                            <SortedAscendingHeaderStyle BackColor="#CAC9C9" />
                            <SortedDescendingCellStyle BackColor="#F1F1F1" />
                            <SortedDescendingHeaderStyle BackColor="#383838" />
                        </asp:GridView>
                    </div>
                    <asp:SqlDataSource ID="SqlDataSource_ActivitiesList" runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="SELECT activity_id, activity_name FROM activity ORDER BY activity_name"></asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDataSource_MaterialsList" runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="SELECT material_id, CONCAT(book_title, '： ', book_chapter) AS display_text FROM material ORDER BY book_title"></asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDataSource_viewActivity" runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT 
                                s.schedule_id,
                                a.activity_id,
                                a.activity_name,
                                s.activity_date,
                                sm.material_id,
                                (m.book_title + ': ' + CAST(m.book_chapter AS NVARCHAR(50))) AS display_text
                            FROM activitySchedule s
                            INNER JOIN activity a ON s.activity_id = a.activity_id
                            LEFT JOIN scheduleMaterial sm ON s.schedule_id = sm.schedule_id
                            LEFT JOIN material m ON sm.material_id = m.material_id
                            WHERE (YEAR(s.activity_date) = @Year OR @Year = 0)
                            AND a.activity_name != '儿童诗班' ORDER BY s.activity_date ASC">
                        <SelectParameters>
                            <asp:Parameter Name="Year" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
</asp:Content>