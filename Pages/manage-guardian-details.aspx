<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="manage-guardian-details.aspx.vb" Inherits="sunday_school_ms.manage_guardian_details" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">

    <title>Manage Guardian Details</title>
    
    <style>
        table {border-collapse: collapse;width: auto;}
        th, td {border: 1px solid #ccc;padding: 8px;text-align:center;}
        .scroll-container {width: 100%;overflow-x: auto;}
        .my-grid {min-width: 80%;table-layout: fixed; text-align:center;}
        .role-radio-list input[type="radio"] { margin-right: 6px;}
        .role-radio-list label {font-size: 16px; margin-bottom: 8px;display: block; cursor: pointer;}
        .btn-disabled {background-color: #cccccc !important;color: #666666 !important;border: 1px solid #aaaaaa !important;cursor: not-allowed !important;}
        .modal-body label {font-weight: 500;}
        </style>

    </asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="menu-container">
        <div class="right-menu-container">
            <div class="filter-menu">
                <div class="filter-wrapper">
                    <h3>家长资料管理</h3>
                    <asp:Button ID="BtnReturn" runat="server" CssClass="btn-normal" Style="border-radius: 5px;" Text="⏎ 回去" />
                </div>
            </div>
            <hr />
            <div class="filter-menu">
                <div class="filter-wrapper">
                    <asp:RadioButtonList ID="RblSearchGender" runat="server"
                        AutoPostBack="True"
                        CssClass="pill-radio"
                        RepeatDirection="Horizontal"
                        AppendDataBoundItems="True">
                        <asp:ListItem Text="全部" Value="ALL" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="男家长" Value="1" />
                        <asp:ListItem Text="女家长" Value="2" />
                    </asp:RadioButtonList>
                </div>
            </div>
            <br />
            <div class="scroll-container">
                <asp:GridView ID="GridView_Guardian" runat="server" CssClass="my-grid"
                    AllowPaging="True" PageSize="30" AllowSorting="True" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
                    CellPadding="3" DataSourceID="SqlDataSource_guardianInfo"
                    ForeColor="Black" GridLines="Vertical"
                    DataKeyNames="person_id, staff_id" OnRowUpdating="GridView_Guardian_RowUpdating"
                    OnRowDataBound="GridView_Guardian_RowDataBound">

                    <AlternatingRowStyle BackColor="#CCCCCC" />

                    <Columns>
                        <asp:BoundField DataField="staff_id" Visible="false" />
                        <asp:TemplateField HeaderText="老师" HeaderStyle-Width="80">
                            <ItemTemplate>
                                <asp:Button ID="BtnTeacher" runat="server"
                                    Text="注册"
                                    CommandName="ToggleTeacher"
                                    CommandArgument='<%# Eval("person_id") %>'
                                    CssClass="btn-selection" />
                            </ItemTemplate>
                            <HeaderStyle Width="80px"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:CommandField ShowEditButton="True" HeaderText="编辑">
                            <ItemStyle Width="80px"></ItemStyle>
                        </asp:CommandField>
                        <asp:BoundField DataField="first_name" HeaderText="姓名(英)">
                            <ItemStyle Width="200px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="last_name" HeaderText="姓氏(英)" SortExpression="last_name">
                            <ItemStyle Width="120px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="chinese_name" HeaderText="姓名(中)">
                            <ItemStyle Width="120px"></ItemStyle>
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="联络号码" HeaderStyle-Width="150">
                            <ItemTemplate><%# FormatContact(Eval("contact_no").ToString()) %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtContactNo" runat="server" Text='<%# Bind("contact_no") %>' Width="120px"></asp:TextBox>
                            </EditItemTemplate>

                            <HeaderStyle Width="150px"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="性别" HeaderStyle-Width="80">
                            <ItemTemplate><%# If(Eval("gender").ToString()="1","男","女") %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlGender" runat="server" SelectedValue='<%# Bind("gender") %>'>
                                    <asp:ListItem Text="男" Value="1" />
                                    <asp:ListItem Text="女" Value="2" />
                                </asp:DropDownList>
                            </EditItemTemplate>

                            <HeaderStyle Width="80px"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="孩子" HeaderStyle-Width="250">
                            <ItemTemplate>
                                <%# Eval("child_name") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlChild" runat="server"
                                    DataSourceID="SqlDataSource_ChildList"
                                    DataTextField="chinese_name"
                                    DataValueField="child_id"
                                    SelectedValue='<%# Bind("child_id") %>'>
                                </asp:DropDownList>
                            </EditItemTemplate>

                            <HeaderStyle Width="250px"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="关系" HeaderStyle-Width="80">
                            <ItemTemplate>
                                <%# Eval("relation_type") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlRelation" runat="server">
                                    <asp:ListItem Text="父亲" Value="父亲" />
                                    <asp:ListItem Text="母亲" Value="母亲" />
                                    <asp:ListItem Text="公公" Value="公公" />
                                    <asp:ListItem Text="婆婆" Value="婆婆" />
                                    <asp:ListItem Text="其他" Value="其他" />
                                </asp:DropDownList>
                            </EditItemTemplate>

                            <HeaderStyle Width="80px"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="出生日期" HeaderStyle-Width="100">
                            <ItemTemplate>
                                <%# Eval("dob", "{0:dd-MM}") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtDOB" runat="server" Text='<%# Bind("dob", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="date-picker" />
                            </EditItemTemplate>

                            <HeaderStyle Width="100px"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:BoundField DataField="age" HeaderText="年龄" ReadOnly="True">
                            <ItemStyle Width="80px"></ItemStyle>
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="信仰" HeaderStyle-Width="100">
                            <ItemTemplate><%# If(Eval("religion").ToString()="1","基督徒","非基督徒") %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlReligion" runat="server" SelectedValue='<%# Bind("religion") %>'>
                                    <asp:ListItem Text="基督徒" Value="1" />
                                    <asp:ListItem Text="非基督徒" Value="0" />
                                </asp:DropDownList>
                            </EditItemTemplate>

                            <HeaderStyle Width="100px"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:BoundField DataField="street_address" HeaderText="街道地址">
                            <ItemStyle Width="550px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="city" HeaderText="城市">
                            <ItemStyle Width="80px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="postcode" HeaderText="邮政编码">
                            <ItemStyle Width="100px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="state_province" HeaderText="州 / 省">
                            <ItemStyle Width="80px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="country" HeaderText="国家">
                            <ItemStyle Width="80px"></ItemStyle>
                        </asp:BoundField>

                    </Columns>
                    <EditRowStyle BorderColor="#FFE9A7" />
                    <FooterStyle BackColor="#CCCCCC" />
                    <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#FFE9A7" Font-Bold="False" ForeColor="Black" CssClass="selectedRow" />
                    <SortedAscendingCellStyle BackColor="" />
                    <SortedAscendingHeaderStyle BackColor="#CAC9C9" />
                    <SortedDescendingCellStyle BackColor="#F1F1F1" />
                    <SortedDescendingHeaderStyle BackColor="#383838" />
                </asp:GridView>
            </div>
            <asp:SqlDataSource ID="SqlDataSource_ChildList" runat="server"
                ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                SelectCommand="SELECT child_id, chinese_name FROM child ORDER BY first_name" />

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

            <asp:SqlDataSource ID="SqlDataSource_ServiceType" runat="server"
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

            <asp:SqlDataSource ID="SqlDataSource_guardianInfo" runat="server"
                ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                SelectCommand="
                        SELECT 
                            p.person_id,
                            p.first_name,
                            p.last_name,
                            p.chinese_name,
                            p.contact_no,
                            p.gender,
                            p.dob,
                            p.age,
                            gu.religion,
                            a.street_address,
                            a.city,
                            a.postcode,
                            a.state_province,
                            a.country,
                            re.child_id,
                            re.relation_type,
                            c.chinese_name + ' (' + c.first_name + ')' AS child_name,
                            c.isArchive,
                            s.staff_id
                        FROM person_roles p
                        INNER JOIN address a ON p.address_id = a.address_id
                        INNER JOIN guardian gu ON p.person_id = gu.person_id
                        LEFT JOIN staff s ON p.person_id = s.person_id
                        LEFT JOIN relationship re ON gu.guardian_id = re.guardian_id
                        LEFT JOIN child c ON re.child_id = c.child_id
                        WHERE p.isGuardian = 1
                        AND c.isArchive = 0
                        AND (@gender = 'All' OR p.gender = @gender)"
                UpdateCommand="
                        UPDATE person
                        SET first_name=@first_name,
                            last_name=@last_name,
                            chinese_name=@chinese_name,
                            contact_no=@contact_no,
                            gender=@gender,
                            dob=@dob
                        WHERE person_id=@person_id;

                        UPDATE guardian
                        SET religion=@religion
                        WHERE person_id=@person_id;

                        UPDATE address
                        SET street_address=@street_address,
                            city=@city,
                            postcode=@postcode,
                            state_province=@state_province,
                            country=@country
                        WHERE address_id=(SELECT address_id FROM person WHERE person_id=@person_id);">
                <SelectParameters>
                    <asp:ControlParameter ControlID="rblSearchGender" Name="gender" PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="first_name" Type="String" />
                    <asp:Parameter Name="last_name" Type="String" />
                    <asp:Parameter Name="chinese_name" Type="String" />
                    <asp:Parameter Name="contact_no" Type="String" />
                    <asp:Parameter Name="gender" Type="String" />
                    <asp:Parameter Name="dob" Type="DateTime" />
                    <asp:Parameter Name="religion" Type="String" />
                    <asp:Parameter Name="street_address" Type="String" />
                    <asp:Parameter Name="city" Type="String" />
                    <asp:Parameter Name="postcode" Type="String" />
                    <asp:Parameter Name="state_province" Type="String" />
                    <asp:Parameter Name="country" Type="String" />
                    <asp:Parameter Name="child_id" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>

        </div>
    </div>

    <!-- Teacher Popup Modal -->
    <div class="modal fade" id="TeacherModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content p-4">

                <div class="modal-header">
                    <h5 class="modal-title">选择角色与事奉项目</h5>
                    <asp:Label runat="server" ID="TxtName"></asp:Label>
                </div>

                <div class="modal-body">
                    <!-- Role Radio Button -->
                    <label>角色<span style="color: red;">*</span></label>
                    <asp:RadioButtonList ID="RblRole" runat="server" CssClass="form-control"
                        DataSourceID="SqlDataSource_Roles"
                        DataTextField="role_chinese"
                        DataValueField="role_english"
                        AutoPostBack="False"
                        RepeatDirection="Horizontal"
                        AppendDataBoundItems="True">
                    </asp:RadioButtonList>

                    <br />

                    <!-- Service Checkbox -->
                    <label>事奉项目<span style="color: red;">*</span></label>
                    <div>
                        <asp:CheckBoxList ID="CblServiceType" runat="server"
                            CssClass="form-control"
                            RepeatLayout="Table"
                            RepeatColumns="4"
                            RepeatDirection="Horizontal"
                            AutoPostBack="False"
                            DataSourceID="SqlDataSource_serviceList"
                            DataTextField="service_type"
                            DataValueField="serviceList_id">
                        </asp:CheckBoxList>
                        <asp:SqlDataSource ID="SqlDataSource_serviceList" runat="server"
                            ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                            SelectCommand="SELECT serviceList_id, service_type FROM [serviceList]"></asp:SqlDataSource>
                    </div>
                    <br />

                    <!-- Start Date TextBox -->
                    <label>开始时间<span style="color: red;">*</span></label>
                    <asp:TextBox ID="TxtStartDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>

                    <br />

                    <!-- Email TextBox -->
                    <label>电邮（如有，用于系统登录）</label>
                    <asp:TextBox ID="TxtEmail" runat="server" TextMode="Email" CssClass="form-control"></asp:TextBox>
                    <br />
                </div>

                <div class="modal-footer">
                    <asp:Button ID="BtnSubmit" runat="server" Text="提交注册" CssClass="btn-selection" />
                </div>
            </div>
        </div>
    </div>
    <!-- END Teacher Popup Modal -->

</asp:Content>
