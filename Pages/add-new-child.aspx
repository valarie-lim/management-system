<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="add-new-child.aspx.vb" Inherits="sunday_school_ms.add_new_child" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Add New Child</title>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="menu-container">
        <div class="right-menu-container">
            <div class="filter-menu">
                <h4>添加新的儿童</h4>
            </div>
            <hr />
            <h6>请输入儿童的资料。</h6>
            <div class="form-container">
                <p>个人信息</p>
                <!-- First Name -->
                <div class="form-field">
                    <label for="firstName">姓名(英)<span style="color:red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtFirstName" runat="server"
                        CssClass="textbox-size"
                        ToolTip="Given Name" Placeholder="Grace En Dian"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="CheckFirstName" runat="server"
                        ErrorMessage="请输入孩子的英文姓名。"
                        ControlToValidate="TxtFirstName"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                </div>
                    </div>
                <br />
                <!-- Last Name -->
                <div class="form-field">
                    <label for="lastName">姓氏(英)<span style="color:red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtLastName" runat="server"
                        CssClass="textbox-size"
                        ToolTip="Family Name" Placeholder="Lee"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="CheckLastName" runat="server"
                        ErrorMessage="请输入孩子的英文姓氏。"
                        ControlToValidate="TxtLastName"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                </div>
                    </div>
                <br />
                <!-- Chinese Name -->
                <div class="form-field">
                    <label for="chineseName">姓名(中)<span style="color: red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtChineseName" runat="server"
                        CssClass="textbox-size"
                        ToolTip="Chinese Name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="CheckChineseName" runat="server"
                        ErrorMessage="请输入孩子的中文姓名。"
                        ControlToValidate="TxtChineseName"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                </div>
                    </div>
                <br />
                <!-- Gender Radio Button-->
                <div class="form-field">
                    <label for="gender">性别<span style="color:red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:RadioButtonList ID="RblGender" runat="server"
                        GroupName="gender"
                        RepeatDirection="Horizontal"
                        RepeatLayout="Flow"
                        CssClass="pill-radio">
                        <asp:ListItem Text="男" Value="男"></asp:ListItem>
                        <asp:ListItem Text="女" Value="女"></asp:ListItem>
                    </asp:RadioButtonList>
                    <asp:RequiredFieldValidator ID="CheckGender" runat="server"
                        ErrorMessage="请选择孩子的性别。"
                        ControlToValidate="RblGender"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                </div>
                    </div>
                <br />
                <!-- Date of Birth -->
                <div class="form-field">
                    <label for="dateOfBirth">出生日期<span style="color:red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtDateOfBirth" runat="server"
                        Width="250px" CssClass="textbox-size"
                        TextMode="Date"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="CheckDateOfBirth" runat="server"
                        ErrorMessage="请输入出生日期"
                        ControlToValidate="TxtDateOfBirth"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CvDateOfBirthYearOnly" runat="server"
                        ControlToValidate="TxtDateOfBirth"
                        ClientValidationFunction="ValidateDOBYearOnly"
                        ErrorMessage="儿童出生日期必须为13岁或以下。"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ValidationGroup="RequiredFieldValidate">
                    </asp:CustomValidator>
                </div>
                    </div>
                <br />
                <p>其他信息</p>
                <!-- Religion Radio Button -->
                <div class="form-field">
                    <label for="RblReligion">信仰<span style="color:red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:RadioButtonList ID="RblReligion" runat="server"
                        RepeatDirection="Horizontal"
                        RepeatLayout="Flow"
                        CssClass="pill-radio">
                        <asp:ListItem Text="基督徒" Value="基督徒"></asp:ListItem>
                        <asp:ListItem Text="非基督徒" Value="非基督徒"></asp:ListItem>
                    </asp:RadioButtonList>
                    <asp:RequiredFieldValidator ID="CheckReligion" runat="server"
                        ErrorMessage="请选择儿童的信仰。"
                        ControlToValidate="RblReligion"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                </div>
                    </div>
                <br />
                <!-- Joined Date -->
                <div class="form-field">
                    <label>第一次参加<span style="color:red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtJoinedDate" runat="server"
                        Width="250px" CssClass="textbox-size"
                        TextMode="Date"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="CheckJoinedDate" runat="server"
                        ErrorMessage="请选择第一次参加。"
                        ControlToValidate="TxtJoinedDate"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RvTxtJoinedDate" runat="server"
                        ControlToValidate="TxtJoinedDate"
                        ErrorMessage="日期不能超过今天！"
                        MinimumValue="2000-01-01"
                        MaximumValue="2099/12/31"
                        Type="Date"
                        Display="Dynamic"
                        CssClass="validator-font"
                        ValidationGroup="RequiredFieldValidate"></asp:RangeValidator>
                </div>
                    </div>
                <br />
                <!-- Inviter -->
                <div class="form-field">
                    <label>带领者</label>
                    <asp:TextBox ID="TxtInviter" runat="server"
                        CssClass="textbox-size"
                        ToolTip="Inviter Name"></asp:TextBox>
                </div>
                <br />
                <!-- Church -->
                <div class="form-field">
                    <label>所属教会</label>
                    <asp:TextBox ID="TxtChurch" runat="server"
                        CssClass="textbox-size"
                        ToolTip="Church"></asp:TextBox>
                </div>
                <br />
                <!-- School -->
                <div class="form-field">
                    <label>学校</label>
                    <asp:TextBox ID="TxtSchool" runat="server"
                        CssClass="textbox-size"
                        ToolTip="School"></asp:TextBox>
                </div>
                <br />
                <!-- Remark -->
                <div class="form-field">
                    <label>备注</label>
                    <asp:TextBox ID="TxtRemark" runat="server"
                        CssClass="textbox-size"
                        ToolTip="Remark" TextMode="MultiLine"></asp:TextBox>
                </div>
                <br />
                <!-- Buttons -->
                <div class="btn-form-align">
                    <asp:Button ID="BtnConfirm" runat="server" Text="确认资料" 
                        CssClass="btn-insert" ClientIDMode="Static"
                        ValidationGroup="RequiredFieldValidate"
                        CausesValidation="True" />
                    <asp:Button ID="BtnCancel" runat="server" Text="取消"
                        CssClass="btn-cancel" ClientIDMode="Static"
                        OnClientClick="return confirm('取消操作后，所有未保存的数据都将丢失。您确定吗？');"/>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function ValidateDOBYearOnly(sender, args) {
            if (!args.Value) {
                args.IsValid = false; // empty field is invalid
                return;
            }

            // Parse the input date
            var inputDate = new Date(args.Value);
            if (isNaN(inputDate.getTime())) {
                args.IsValid = false; // invalid date format
                return;
            }

            var birthYear = inputDate.getFullYear();
            var currentYear = new Date().getFullYear();

            var age = currentYear - birthYear;

            // Only allow age <= 13
            args.IsValid = (age <= 13);
        }
    </script>
</asp:Content>
